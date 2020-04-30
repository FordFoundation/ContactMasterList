using System;

namespace Import_MailChimp_To_SQL
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                API_Process obj_mailchimp = new API_Process();
                if (args.Length >0)
                {
                    int Day = Int32.Parse(args[0]); //-1 (or)-30
                    obj_mailchimp.ArgDay = Day;
                }
                obj_mailchimp.ProcessMailchimpUser();
                
                
            }
            catch(Exception ex)
            {               
                Logger.LogException("Main method error:"+ex.Message);
                Environment.Exit(-1);
            }
        }
    }
}
