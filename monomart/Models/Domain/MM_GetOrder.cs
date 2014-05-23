using System;

namespace monomart.Models.Domain
{
    public class MM_GetOrder
    {
        public virtual int id { get; set; }
        public virtual string order_guid { get; set; }
        public virtual string order_ip { get; set; }
        public virtual System.DateTime order_date { get; set; }
        public virtual int order_status { get; set; }
        public virtual string customer_name { get; set; }
        public virtual string customer_email { get; set; }
        public virtual string phone_number { get; set; }
        public virtual string ship_to_name { get; set; }
        public virtual string ship_to_address1 { get; set; }
        public virtual string ship_to_address2 { get; set; }
        public virtual string ship_to_city { get; set; }
        public virtual string ship_to_country { get; set; }
        public virtual string ship_to_state { get; set; }
        public virtual string ship_to_zip { get; set; }
    }
}
