using System;

namespace monomart.Models.Domain
{
    
    public class MM_GetProducts
    {
        public virtual int id { get; set; }
        public virtual string brand { get; set; }
        public virtual string name { get; set; }
        public virtual string size { get; set; }
        public virtual string upc { get; set; }
        public virtual decimal price { get; set; }
        public virtual string ingredients { get; set; }
        public virtual string servings { get; set; }
        public virtual string servingsize { get; set; }
        public virtual string image { get; set; }
    }
}
