using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Configuration;
using System.Diagnostics;
using System.Net.Mail;
using System.Data;

namespace Import_MailChimp_To_SQL
{
    public static class Logger
    {
        private static String _logFolder = ConfigurationManager.AppSettings["LogFolder"];
        private static string _logFileName = ConfigurationManager.AppSettings["LogFileName"];
        private static string _logFileNameDateFormat = ConfigurationManager.AppSettings["LogFileNameDateFormat"];
        private static Object _LOCK = new Object();

        private static void Log(LogType logType, DateTime dateTime, String title, String body, Boolean IsEventLog = false)
        {

            string ExecutablePath = AppDomain.CurrentDomain.BaseDirectory + "\\";
            lock (_LOCK)
            {
                var logDirectory = ExecutablePath + _logFolder;

                var ArchiveDirectory = logDirectory + "\\Archive";

                if (!Directory.Exists(logDirectory))
                {
                    Directory.CreateDirectory(logDirectory);
                }

                var logFileName = _logFileName + "_" + DateTime.Now.ToString(_logFileNameDateFormat);
                var logFile = Path.Combine(logDirectory, logFileName + ".txt");

                foreach (string fileName in Directory.GetFiles(logDirectory, _logFileName + "*.txt"))
                {
                    if (fileName != logFile)
                    {
                        if (!Directory.Exists(ArchiveDirectory))
                            Directory.CreateDirectory(ArchiveDirectory);
                        var archiveFileName = Path.Combine(ArchiveDirectory, Path.GetFileName(fileName));
                        if (File.Exists(archiveFileName))
                            File.Delete(archiveFileName);
                        File.Move(fileName, archiveFileName);
                    }

                }


                using (StreamWriter writer = new StreamWriter(logFile, true))
                {
                    writer.WriteLine(String.Format("{0} {1} {2}", logType == LogType.Success ? "++++++++" : "--------", title, dateTime.ToString("MM/dd/yyyy HH:mm:ss")));
                    writer.WriteLine(body);
                    if (title != "Information")
                        writer.WriteLine(Environment.NewLine);
                }
            }
            if (IsEventLog)
            {
                //WriteEventLog(body);
            }

        }

        public static void LogSuccess(String Message)
        {
            Log(LogType.Success, DateTime.Now, LogType.Success.ToString(), Message);
        }
        public static void LogInformation(String Message)
        {
            Log(LogType.Success, DateTime.Now, LogType.Information.ToString(), Message);
        }

        public static void LogException(String stackTrace, Boolean IsEventLog = false)
        {
            Log(LogType.Error, DateTime.Now, LogType.Error.ToString(), stackTrace, IsEventLog);
        }

        public static string GetConfigValueByKey(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }
        public static void WriteEventLog(string ErrorMsg)
        {
            string source = GetConfigValueByKey("ErrorSource");
            try
            {
                //if (!EventLog.SourceExists(source))
               //     EventLog.CreateEventSource(source, "Application");
               // EventLog.WriteEntry(source, ErrorMsg, EventLogEntryType.Error);
            }
            catch (Exception ex)
            {
                Logger.LogException(ex.StackTrace);
            }
        }

        public static void WriteCsvFile(this DataTable dataTable, string filePath, bool IncludeHeader = true)

        {
            using (var writer = new StreamWriter(filePath))
            {
                if (IncludeHeader)
                    writer.WriteLine(string.Join(",", dataTable.Columns.Cast<DataColumn>().Select(dc => dc.ColumnName)));
                foreach (DataRow row in dataTable.Rows)
                {
                    writer.WriteLine(string.Join(",", row.ItemArray));
                }
            }


        }
    }

    public enum LogType
    {
        Success,
        Error,
        Information
    }
    public static class Utility
    {
        public static string GetConfigValueByKey(string key)
        {
            return ConfigurationManager.AppSettings[key];
        }
    }
    public class MailUtility
    {


        public void SendEmail(string MailBody)
        {
            try
            {
                string Subject = Utility.GetConfigValueByKey("Subject");
                string SMTPServer = Utility.GetConfigValueByKey("SMTPServer");
                int Port = int.Parse(Utility.GetConfigValueByKey("Port"));
                string UserName = Utility.GetConfigValueByKey("UserName");
                string Password = Utility.GetConfigValueByKey("Password");
                string From = Utility.GetConfigValueByKey("From");
                string To = Utility.GetConfigValueByKey("To");
                string Domain = Utility.GetConfigValueByKey("Domain");

                MailMessage mailMsg = new MailMessage();
                //Add Email Group/s
                if (To != null)
                {
                    foreach (var address in To.Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries))
                    {
                        mailMsg.To.Add(address);
                    }
                }

                //From
                MailAddress mailAddress = new MailAddress(From);
                mailMsg.From = mailAddress;
                //Subject
                mailMsg.Subject = Subject;
                //Body
                mailMsg.Body = MailBody;
                mailMsg.IsBodyHtml = true;
                //Priority                
                mailMsg.Priority = MailPriority.High;
                // Init SmtpClient and send
                SmtpClient smtpClient = new SmtpClient(SMTPServer, Port);
                //smtpClient.Timeout = 10000;
                smtpClient.EnableSsl = true;
                smtpClient.Credentials = new System.Net.NetworkCredential(UserName, Password, Domain);
                smtpClient.UseDefaultCredentials = true;
                smtpClient.DeliveryMethod = SmtpDeliveryMethod.Network;
                System.Net.ServicePointManager.ServerCertificateValidationCallback = delegate (object s,
               System.Security.Cryptography.X509Certificates.X509Certificate certificate,
               System.Security.Cryptography.X509Certificates.X509Chain chain,
               System.Net.Security.SslPolicyErrors sslPolicyErrors)
                {
                    return true;
                };
                smtpClient.Send(mailMsg);
                mailMsg.Dispose();

            }
            catch (Exception ex)
            {
                string error = ex.Message;
                //Console .WriteLine(ex.Message.ToString());
                Logger.LogException(ex.Message);
                //  throw;
            }
        }
    }

}


