using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;

namespace Import_MailChimp_To_SQL
{
    
    class API_Process
    {
        public StringBuilder ErrorStringBuilder = new StringBuilder();
        public int ArgDay = 0;
        public string APIToken = string.Empty;
        public string ExecutablePath = string.Empty;
        public string FilePath = string.Empty;
        public string ArchiveFilePath = string.Empty;
        public string FileTimeStamp = string.Empty;
        public ArrayList objMembersList = new ArrayList();
        MailChimp_Props objprops = new MailChimp_Props();
        Dictionary<string, string> dict_SubscribeTo = new Dictionary<string, string>();
        Dictionary<string, string> dict_TellUs = new Dictionary<string, string>();
        Dictionary<string, string> dict_FordFound = new Dictionary<string, string>();
        Dictionary<string, string> dict_GranteeByReg = new Dictionary<string, string>();
        Dictionary<string, string> dict_GranteeByProg = new Dictionary<string, string>();
        Dictionary<string, string> dict_559d = new Dictionary<string, string>();
        ArrayList objMemberInterest = new ArrayList();
        ArrayList objTags = new ArrayList();
        public DataTable dtMember = new DataTable();
        private int prevDays = 0;
        private int resFlag = 0;
        public void ProcessMailchimpUser()
        { 

            LoadDirectory();
            if (objprops.AuthToken == string.Empty)
            {
                GetToken.objprops = objprops;
                APIToken = GetToken.Gettoken();
            }
            else
                APIToken = objprops.AuthToken;

            if (ArgDay == 0)
                prevDays = objprops.LastChanged;
            else
                prevDays = ArgDay;

            ProcessmailChimpList();

        }

        public void ProcessmailChimpList()
        {
            try
            {
                Logger.LogInformation("----------------------------------------Process started---------------------------------");
                FileTimeStamp = DateTime.Now.ToString(objprops.FileTimeStamp);
                GetLists(objprops.ListAPI);
                Logger.LogInformation("----------------------------------------Process Completed---------------------------------");
            }
            catch (Exception ex)
            {
                Logger.LogInformation("----------------------------------------Process completed with errors---------------------------------");
                Logger.LogException(ex.Message);
                throw new Exception(ex.Message);
            }

        }
    public void LoadDirectory()
    {
            try
            {
                ExecutablePath = AppDomain.CurrentDomain.BaseDirectory + "\\";
                FilePath = ExecutablePath + objprops.CSVPath;
                ArchiveFilePath = ExecutablePath + objprops.CSVProcessedPath;
                if (!Directory.Exists(FilePath))
                    Directory.CreateDirectory(FilePath);

                if (!Directory.Exists(ArchiveFilePath))
                    Directory.CreateDirectory(ArchiveFilePath);

            }
            catch (Exception ex)
            { 
                throw new Exception("Creating CSV Directory:" + ex.Message);
            }
        }

        public string APIOutput(string URLcontent)
        {
            string output = string.Empty;
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(objprops.URL + URLcontent);
            request.Headers.Add("Authorization", "Basic " + APIToken);
            try
            {
                WebResponse response = request.GetResponse();
                using (Stream responseStream = response.GetResponseStream())
                {
                    StreamReader reader = new StreamReader(responseStream, System.Text.Encoding.UTF8);
                     output = reader.ReadToEnd();
                }
                return output;
            }
            catch (Exception ex)
            {
                Logger.LogException("Error while calling APIs:" + ex.Message);
                throw ex;
            }
        }
        public string GetLists(string URLContent)
        {            
            try
            {
               
                string output = APIOutput(URLContent);
                dynamic array = JObject.Parse(output);
                 int count = array.total_items;
                string[] strListNames = objprops.ListName.ToString().Split(",");
                if (count > 0)
                {
                    CreateDataTable();
                    for (int loop = 0; loop < count; loop++)
                    {
                        if (Array.IndexOf(strListNames, array.lists[loop].name.ToString())>=0)
                        {
                            Logger.LogInformation("Process started for the List:" + array.lists[loop].name.ToString() + ",ListID:" + array.lists[loop].id.ToString());
                            string ListId = array.lists[loop].id.ToString();
                            Getinterestcategories(ListId);
                            GetListMembers(ListId);
                        }
                    } 
                    
                }
                return "";
            }
            catch (Exception ex)
            {
                Logger.LogException("Error while calling APIs:" + ex.Message);
                throw ex;
            }

            }

        public void Getinterestcategories(string ListId)
        {
            try
            {
                dict_SubscribeTo.Clear();
                dict_TellUs.Clear();
                dict_FordFound.Clear();
                dict_GranteeByReg.Clear();
                dict_GranteeByProg.Clear();
                dict_559d.Clear();

                int recCount = objprops.RecCount;
               
                string[] Interests = objprops.InterestCategories.Split(",");                
                string filter = "fields=categories.id,categories.title,categories.list_id,total_items";
                string output = APIOutput("lists/" + ListId + "/interest-categories?count=" + recCount + filter);
                dynamic categoryarray = JObject.Parse(output);
               
                int Totalitems = categoryarray.total_items;
                if (Totalitems > 0)
                {
                    filter = "fields = interests.category_id,interests.list_id,interests.id,interests.name,total_items";
                    for (int loop = 0; loop < Totalitems; loop++)
                    {
                        string CategoryId = categoryarray.categories[loop].id.ToString();
                        string CategoryName= categoryarray.categories[loop].title.ToString();
                        output = APIOutput("lists/" + ListId + "/interest-categories/" + CategoryId + "/interests?count=" + recCount + filter);
                        dynamic interestarray = JObject.Parse(output);
                        int IntTotalitems = interestarray.total_items;
                        if (IntTotalitems > 0)
                        {
                            if ((Interests.Contains(CategoryName)) && CategoryName == "Subscribe to")
                                GetInterestForCategories(interestarray, IntTotalitems, dict_SubscribeTo);
                            else if ((Interests.Contains(CategoryName)) && CategoryName == "Tell us more about your interests")
                                GetInterestForCategories(interestarray, IntTotalitems, dict_TellUs);
                            else if ((Interests.Contains(CategoryName)) && CategoryName == "Ford Foundation")
                                GetInterestForCategories(interestarray, IntTotalitems, dict_FordFound);
                            else if ((Interests.Contains(CategoryName)) && CategoryName == "Grantees by Regions")
                                GetInterestForCategories(interestarray, IntTotalitems, dict_GranteeByReg);
                            else if ((Interests.Contains(CategoryName)) && CategoryName == "Grantees by Program")
                                GetInterestForCategories(interestarray, IntTotalitems, dict_GranteeByProg);
                            else if ((Interests.Contains(CategoryName)) && CategoryName == "155b14559d")
                                GetInterestForCategories(interestarray, IntTotalitems, dict_559d);

                        }

                    }
                }
                Console.WriteLine("Collected All the Interest categroies for the List id:" + ListId);

            }
            catch(Exception ex)
            {
                Logger.LogException("Error while calling APIs:" + ex.Message);
                throw ex;
            }

        }

        public void GetInterestForCategories(dynamic interestarray,int IntTotalitems,Dictionary<string,string> dict)
        {
            try
            {
                for (int innerloop = 0; innerloop < IntTotalitems; innerloop++)
                    dict.Add(interestarray.interests[innerloop].id.ToString(), interestarray.interests[innerloop].name.ToString());
            }
            catch (Exception ex)
            {
                Logger.LogException("Error on while adding Interest on dictionary:" + ex.Message + "Interest array:" + interestarray);                
            }
        }
        public void GetListMembers(string ListId)
        {
            string xmlFile = string.Empty;
            string DestFile = string.Empty;
            try
            {
                
                int recCount=objprops.RecCount;
                int offset = 0;              
                string[] ArrStatus = objprops.MemberStatus.Split(",");
                
                string dt = string.Empty;
                if (prevDays != 0)
                    dt=DateTime.UtcNow.AddDays(prevDays).ToString("s");//.AddDays(-1)

                if (ArrStatus.Length > 0)
                {
                   
                   // CreateDataTable();
                    for (int loop = 0; loop < ArrStatus.Length; loop++)
                    {
                        dtMember.Clear();
                        resFlag = 0;
                        GetMembers(ListId, recCount, offset, dt, ArrStatus[loop]);
                        if (dtMember.Rows.Count > 0)
                        {
                            var XlDs = new DataSet();
                             DestFile = ArchiveFilePath + "\\" + ArrStatus[loop] + "_" + ListId + "_" + FileTimeStamp + ".xml";

                            XlDs.Tables.Add(dtMember);
                            XlDs.DataSetName = "EventResponse";
                            XlDs.Tables[0].TableName = "MailChimp";
                             xmlFile = FilePath+"\\" + ArrStatus[loop] + ".xml";
                            XlDs.Tables[0].WriteXml(xmlFile);
                           string xmlFileContent = File.ReadAllText(xmlFile);

                            InsertToDatabase(xmlFileContent, ArrStatus[loop]);                            
                            dtMember.Rows.Clear();
                            XlDs.Tables.Clear();
                            ArchiveFile(xmlFile, DestFile);

                            //try
                            //{
                            //    File.Copy(xmlFile, DestFile, true);
                            //    File.Delete(xmlFile);
                            //    //File.Move(filePath, DestFile);
                            //}
                            //catch (Exception ex)
                            //{
                            //    Logger.LogException("Not able to delete the file:" + xmlFile);
                            //}

                        }
                        else
                            Logger.LogInformation("There is no record for the status:"+ ArrStatus[loop] +"List ID:"+ ListId);

                    }
                }
              //  else
              //      GetMembers(ListId, recCount, offset, dt,string.Empty);

                Logger.LogInformation("Member info processed to DB for the List id:" + ListId);
            }
            catch (Exception ex)
            {
                DestFile = DestFile.Replace(".xml", "_error.xml");
                ArchiveFile(xmlFile, DestFile);
                Logger.LogException("Error while processing member info for the List id:" + ListId + " : Error messsage:" + ex.Message);
            }

}

        public void ArchiveFile(string source,string Destination)
        {
            try
            {
                File.Copy(source, Destination, true);
                File.Delete(source);
                //File.Move(filePath, DestFile);
            }
            catch (Exception ex)
            {
                Logger.LogException("Not able to delete the file:" + source);
            }
        }

        public void CreateDataTable()
        {
            try
            {               
                string[] ArrTblColumns = objprops.TblColumns.Split(",");
                
                for (int loop = 0; loop < ArrTblColumns.Length; loop++)
                    dtMember.Columns.Add(ArrTblColumns[loop]);
            }
            catch(Exception ex)
            {
                Logger.LogException(ex.Message);
                throw ex;
            }
           
        }
        public void GetMembers(string ListId,int recCount,int offset,string dt,string status)
        {
            try
            {
                int recordsCount = 0;
                
                dt = (dt==string.Empty) ? "" : "&since_last_changed=" + dt;
                status=(status == string.Empty) ? "" : "&status=" + status;
               string filter = dt + status;
                //  string output = APIOutput("lists/" + ListId + "/members?offset=" + offset + "& count=" + recCount + "&since_last_changed=" + dt + "&status=" + status);
                string output = APIOutput("lists/" + ListId + "/members?offset=" + offset + "& count=" + recCount + filter);

                dynamic array = JObject.Parse(output);
            int Totalitems = array.total_items;
                if (Totalitems > recCount)
                    recordsCount = 1000;// recCount;                
                else
                     recordsCount = Totalitems - offset;
                   
                
                if (Totalitems > 0 && resFlag == 0)
            {                  
                  //  objMembersList.Add("{" + array.members + "}");
                    DataRow row;
                    //DataTable tester = Tabulate(output);// (DataTable)JsonConvert.DeserializeObject(array.members.ToString(), (typeof(DataTable)));
                    for (int loop = 0; loop < recordsCount; loop++)
                    {
                        try {
                            string SubscribeTo = string.Empty;
                            string TellUs = string.Empty;
                            string FordFound = string.Empty;
                            string GranteeByReg = string.Empty;
                            string GranteeByProg = string.Empty;
                            string s559d = string.Empty;

                            row = dtMember.NewRow();

                            row["EmailAddress"] = array.members[loop].email_address.ToString();
                            row["Prefix"] = Convert.ToString(array.members[loop].merge_fields["PREFIX"]);
                            row["First_Name"] = Convert.ToString(array.members[loop].merge_fields["FNAME"]);
                            row["Middle_Initial"] = Convert.ToString(array.members[loop].merge_fields["MMERGE41"]);
                            row["Last_Name"] = Convert.ToString(array.members[loop].merge_fields["LNAME"]);
                            row["Full_name"] = Convert.ToString(array.members[loop].merge_fields["FULLNAME"]);
                            row["Job_Title"] = Convert.ToString(array.members[loop].merge_fields["JTITLE"]);
                            row["Organization"] = Convert.ToString(array.members[loop].merge_fields["COMP"]);
                            row["Your_field"] = Convert.ToString(array.members[loop].merge_fields["FIELD"]);
                            row["Position_Type"] = Convert.ToString(array.members[loop].merge_fields["PTYPE"]);
                            row["Region"] = Convert.ToString(array.members[loop].merge_fields["REGION"]);
                            row["Country"] = Convert.ToString(array.members[loop].merge_fields["COUNTRY"]);
                            row["State"] = Convert.ToString(array.members[loop].merge_fields["STATE"]);
                            row["Twitter_username"] = Convert.ToString(array.members[loop].merge_fields["TWITTER"]);
                            row["Grantee_Status"] = Convert.ToString(array.members[loop].merge_fields["GSTATUS"]);
                            row["Telephone"] = Convert.ToString(array.members[loop].merge_fields["PHONE"]);
                            row["Ford_Staff_Category"] = Convert.ToString(array.members[loop].merge_fields["SCAT"]);
                            row["Sources"] = Convert.ToString(array.members[loop].merge_fields["MMERGE16"]);
                            row["Grantee_Organization"] = Convert.ToString(array.members[loop].merge_fields["MMERGE17"]);
                            row["RPO_Office"] = Convert.ToString(array.members[loop].merge_fields["MMERGE18"]);
                            row["Grant_Type"] = Convert.ToString(array.members[loop].merge_fields["MMERGE19"]);
                            row["City"] = Convert.ToString(array.members[loop].merge_fields["MMERGE20"]);
                            row["GPP_Announcement"] = Convert.ToString(array.members[loop].merge_fields["MMERGE21"]);
                            row["Domain_country"] = Convert.ToString(array.members[loop].merge_fields["MMERGE22"]);
                            row["Source_List"] = Convert.ToString(array.members[loop].merge_fields["MMERGE23"]);
                            row["FF_Management_Level"] = Convert.ToString(array.members[loop].merge_fields["MMERGE24"]);
                            row["Cell_Phone"] = Convert.ToString(array.members[loop].merge_fields["MMERGE25"]);
                            row["FF_Department"] = Convert.ToString(array.members[loop].merge_fields["MMERGE26"]);
                            row["FF_Division"] = Convert.ToString(array.members[loop].merge_fields["MMERGE27"]);
                            row["SalesForce_ID"] = Convert.ToString(array.members[loop].merge_fields["SALESFORCE"]);
                            row["GDPR_Compliant"] = Convert.ToString(array.members[loop].merge_fields["MMERGE29"]);
                            row["Domain_from_EU"] = Convert.ToString(array.members[loop].merge_fields["MMERGE30"]);
                            row["Opt-in_date"] = Convert.ToString(array.members[loop].merge_fields["MMERGE31"]);
                            row["Campaign"] = Convert.ToString(array.members[loop].merge_fields["MMERGE32"]);
                            row["GDPR_Compliant_Signup_Form"] = Convert.ToString(array.members[loop].merge_fields["MMERGE33"]);
                            row["May_18_Status"] = Convert.ToString(array.members[loop].merge_fields["MMERGE34"]);
                            row["Fiscal_Year"] = Convert.ToString(array.members[loop].merge_fields["MMERGE35"]);
                            row["RPO"] = Convert.ToString(array.members[loop].merge_fields["MMERGE36"]);
                            row["Grant_Manager"] = Convert.ToString(array.members[loop].merge_fields["MMERGE37"]);
                            row["Tag"] = Convert.ToString(array.members[loop].merge_fields["MMERGE38"]);
                            row["CfSJ_Campaign_Version"] = Convert.ToString(array.members[loop].merge_fields["MMERGE40"]);
                            row["Mailing_Address"] = Convert.ToString(array.members[loop].merge_fields["MMERGE39"]);
                            //row["Zip_Country_Code"] =
                            //row["C/O"] =
                            row["Nominees_YES_Full_Name"] = Convert.ToString(array.members[loop].merge_fields["MMERGE44"]);
                            row["Nominess_NO_Full_Name"] = Convert.ToString(array.members[loop].merge_fields["MMERGE45"]);
                            row["Nominess_ALL_Full_Name"] = Convert.ToString(array.members[loop].merge_fields["MMERGE46"]);
                            row["Candidate_Full_Name"] = Convert.ToString(array.members[loop].merge_fields["MMERGE47"]);
                            row["MEMBER_RATING"] = Convert.ToString(array.members[loop].member_rating);
                            row["OPTIN_TIME"] = Convert.ToString(array.members[loop].timestamp_signup);
                            row["OPTIN_IP"] = Convert.ToString(array.members[loop].ip_signup);
                            row["CONFIRM_TIME"] = Convert.ToString(array.members[loop].timestamp_opt);
                            row["CONFIRM_IP"] = Convert.ToString(array.members[loop].ip_opt);
                            row["LATITUDE"] = Convert.ToString(array.members[loop].location["latitude"]);
                            row["LONGITUDE"] = Convert.ToString(array.members[loop].location["longitude"]);
                            row["GMTOFF"] = Convert.ToString(array.members[loop].location["gmtoff"]);
                            row["DSTOFF"] = Convert.ToString(array.members[loop].location["dstoff"]);
                            row["TIMEZONE"] = Convert.ToString(array.members[loop].location["timezone"]);
                            row["CC"] = Convert.ToString(array.members[loop].location["country_code"]);
                            //  row["REGION1"] =
                            // row["LAST_CHANGED"] = Convert.ToString(array.members[loop].last_changed);  //UNSUB_TIME
                            row["LEID"] = Convert.ToString(array.members[loop].web_id);
                            row["EUID"] = Convert.ToString(array.members[loop].unique_email_id);
                            //row["NOTES"] =
                            //row["TAGS"] = Convert.ToString(array.members[loop].tags);
                            var tag = string.Empty;
                            if (Convert.ToString(array.members[loop].tags) != "[]")
                            {
                                var tags = array.members[loop].tags.ToString();
                                for (int tagloop = 0; tagloop < array.members[loop].tags.Count; tagloop++)
                                {
                                    tag = tag + array.members[loop].tags[tagloop].name.ToString() + ";";
                                }

                            }

                            row["TAGS"] = tag.TrimEnd(';');
                            //UnSubscribe
                            if (array.members[loop].last_changed != null)
                            {
                                row["UNSUB_TIME"] = array.members[loop].last_changed.ToString();  //unsubscribed
                                row["LAST_CHANGED"] = array.members[loop].last_changed.ToString();//subscribed
                                row["CLEAN_TIME"] = array.members[loop].last_changed.ToString();//Cleaned
                            }
                            if (array.members[loop].unsubscribe_reason != null)
                                row["UNSUB_REASON"] = array.members[loop].unsubscribe_reason.ToString();

                            //if (array.members[loop].unsubscribe_campaign_title != null)
                            //row["UNSUB_CAMPAIGN_TITLE"] = array.members[loop].unsubscribe_campaign_title.ToString();
                            //if (array.members[loop].unsubscribe_campaign_id != null)
                            //row["UNSUB_CAMPAIGN_ID"] = array.members[loop].unsubscribe_campaign_id.ToString();                    
                            //if (array.members[loop].unsubscribe_reason_other != null)
                            //    row["UNSUB_REASON_OTHER"] = array.members[loop].unsubscribe_reason_other.ToString();

                            //if (array.members[loop].clean_campaign_title != null)
                            //row["CLEAN_CAMPAIGN_TITLE"] = array.members[loop].clean_campaign_title.ToString();
                            //if (array.members[loop].clean_campaign_id != null)
                            //row["CLEAN_CAMPAIGN_ID"] = array.members[loop].clean_campaign_id.ToString();                    


                            var interest =Convert.ToString( array.members[loop].interests);
                            if (interest != null)
                            {
                                dynamic itemsInterest = JsonConvert.DeserializeObject(interest);
                                objMemberInterest.Clear();
                                foreach (var item in itemsInterest)
                                {
                                    if (item.Value.ToString() == "True")
                                        objMemberInterest.Add(item.Name.ToString());
                                }
                                for (int innerloop = 0; innerloop < objMemberInterest.Count; innerloop++)
                                {
                                    if (dict_SubscribeTo.ContainsKey(objMemberInterest[innerloop].ToString()))
                                        SubscribeTo = SubscribeTo + dict_SubscribeTo[objMemberInterest[innerloop].ToString()] + ";";
                                    else if (dict_TellUs.ContainsKey(objMemberInterest[innerloop].ToString()))
                                        TellUs = TellUs + dict_TellUs[objMemberInterest[innerloop].ToString()] + ";";
                                    else if (dict_FordFound.ContainsKey(objMemberInterest[innerloop].ToString()))
                                        FordFound = FordFound + dict_FordFound[objMemberInterest[innerloop].ToString()] + ";";
                                    else if (dict_GranteeByReg.ContainsKey(objMemberInterest[innerloop].ToString()))
                                        GranteeByReg = GranteeByReg + dict_GranteeByReg[objMemberInterest[innerloop].ToString()] + ";";
                                    else if (dict_GranteeByProg.ContainsKey(objMemberInterest[innerloop].ToString()))
                                        GranteeByProg = GranteeByProg + dict_GranteeByProg[objMemberInterest[innerloop].ToString()] + ";";
                                    else if (dict_559d.ContainsKey(objMemberInterest[innerloop].ToString()))
                                        s559d = s559d + dict_559d[objMemberInterest[innerloop].ToString()] + ";";
                                }
                            }
                            row["Subscribe_to"] = SubscribeTo.TrimEnd(';');
                            row["Tell_us_more_about_your_interests"] = TellUs.TrimEnd(';');
                            row["Ford_Foundation"] = FordFound.TrimEnd(';');
                            row["Grantees_by_Regions"] = GranteeByReg.TrimEnd(';');
                            row["Grantees_by_Program"] = GranteeByProg.TrimEnd(';');
                            row["Int155b14559d"] = s559d.TrimEnd(';');

                            dtMember.Rows.Add(row);
                        }
                        catch (Exception ex)
                        {
                            Logger.LogException("Error for the member:" + array.members[loop].email_address.ToString() +":Error message:"+ex.Message);
                        }
                    }
                    if (recCount < Totalitems)
                    {
                        offset = recCount;
                        recCount = recCount + 1000;
                        GetMembers(ListId, recCount, offset, dt, status);
                    }
                    else
                        resFlag = 1;



            }
                //return  objMembersList;
            }
            catch (Exception ex)
            {
                Logger.LogException("Error while calling member APIs:" + ex.Message);
               throw ex;
            }
        }

        public void InsertToDatabase(string xmlData, string Status)
        {
            
            try
            {
                string outputval = string.Empty;
                if (xmlData != null)
                {
                    Logger.LogInformation("Started insert/update procecss to database for the status:" + Status);
                    using (SqlConnection connection = new SqlConnection(objprops.connectionString))
                    {
                        using (var cmd = new SqlCommand(objprops.SPName))
                        {
                            cmd.Connection = connection;
                            cmd.CommandTimeout = 300;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.Parameters.AddWithValue("@MailChimpRespXml", xmlData);
                            cmd.Parameters.AddWithValue("@UserType", Status);
                            connection.Open();
                            cmd.ExecuteNonQuery();
                            connection.Close();
                            Logger.LogInformation("Insert/updated data successfully.");

                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Logger.LogInformation("Error while processing to database:" + ex.Message);
                throw ex;
            }

        }
        //not used
        public static DataTable Tabulate(string json)
        {
            try
            {
                var jsonLinq = JObject.Parse(json);

                // Find the first array using Linq
                var srcArray = jsonLinq.Descendants().Where(d => d is JArray).First();
                var trgArray = new JArray();
                foreach (JObject row in srcArray.Children<JObject>())
                {
                    var cleanRow = new JObject();
                    foreach (JProperty column in row.Properties())
                    {
                        // Only include JValue types
                        if (column.Value is JValue)
                        {
                            cleanRow.Add(column.Name, column.Value.ToString());
                        }
                    }

                    trgArray.Add(cleanRow);
                }

                return JsonConvert.DeserializeObject<DataTable>(trgArray.ToString());
            }
            catch (Exception ex)
            {
                Logger.LogException(ex.Message);
                return null;
            }
        }

       
    }
   

}
