using System;
using System.Collections.Generic;
using System.Text;

namespace Import_MailChimp_To_SQL
{
    class MailChimp_Props
    {
        public string UserId { get { return Utility.GetConfigValueByKey("UserId"); } }
        public string APIKey { get { return Utility.GetConfigValueByKey("APIKey"); } }
        public string URL { get { return Utility.GetConfigValueByKey("URL"); } }
        public string ListAPI { get { return Utility.GetConfigValueByKey("Lists"); } }

        public string ListName { get { return Utility.GetConfigValueByKey("ListName"); } }
        public int LastChanged { get { return Convert.ToInt32(Utility.GetConfigValueByKey("LastChanged")); } }
        public string InterestCategories { get { return Utility.GetConfigValueByKey("InterestCategories"); } }       
        public string TblColumns { get { return Utility.GetConfigValueByKey("TblColumns"); } }
        public string SPName { get { return Utility.GetConfigValueByKey("SPName"); } }
        public string connectionString { get { return Utility.GetConfigValueByKey("connectionString"); } }
        public string CSVPath { get { return Utility.GetConfigValueByKey("CSVPath"); } }
        public string CSVName { get { return Utility.GetConfigValueByKey("CSVName"); } }
        public string Extn { get { return Utility.GetConfigValueByKey("Extn"); } }
        public string Seperator { get { return Utility.GetConfigValueByKey("Seperator"); } }
        public string Delimeter { get { return Utility.GetConfigValueByKey("Delimeter"); } }
        public string FileTimeStamp { get { return Utility.GetConfigValueByKey("FileTimeStamp"); } }
        public string CSVProcessedPath { get { return Utility.GetConfigValueByKey("CSVProcessedPath"); } }
        public string AuthType { get { return Utility.GetConfigValueByKey("AuthType"); } }
        public string AuthToken { get { return Utility.GetConfigValueByKey("AuthToken"); } }
        public int RecCount { get { return Convert.ToInt32(Utility.GetConfigValueByKey("RecCount")); } }
        public string MemberStatus { get { return Utility.GetConfigValueByKey("MemberStatus"); } }

    }
}
