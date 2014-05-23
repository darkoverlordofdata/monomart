using System;
using System.Reflection;
using System.Collections.Generic;
using NHibernate;
using NHibernate.Cfg;
using NHibernate.Transform;
using monomart.Models.Domain;

namespace monomart.Models 
{
	public class MonomartEntities : IMonomartEntities
	{
		Configuration config;


		public MonomartEntities () {

			config = new Configuration();
			config.Configure();
			config.AddAssembly(Assembly.GetExecutingAssembly());
		}

		public int MM_DelCart(int orderId) {

			ISessionFactory factory = config.BuildSessionFactory();
			using (ISession session = factory.OpenSession()) {

				var sp = session.GetNamedQuery("MM_DelCart");

				sp.SetInt32("orderId", orderId);
				sp.UniqueResult();
				session.Close();

			}
			factory.Close();
			return 0;


		}

		public IList<MM_GetBrand> MM_GetBrand(int id) {

			IList<MM_GetBrand> result = new List<MM_GetBrand>();

			ISessionFactory factory = config.BuildSessionFactory();
			using (ISession session = factory.OpenSession()) {

				var sp = session.GetNamedQuery("MM_GetBrand");

				sp.SetInt32("id", id);
				result = sp.SetResultTransformer(Transformers.AliasToBean(typeof(MM_GetBrand)))
					.List<MM_GetBrand>();
				session.Close();

			}
			factory.Close();
			return result;

		}

		public IList<MM_GetCart> MM_GetCart(int orderId) {

			IList<MM_GetCart> result = new List<MM_GetCart>();

			ISessionFactory factory = config.BuildSessionFactory();
			using (ISession session = factory.OpenSession()) {

				var sp = session.GetNamedQuery("MM_GetCart");

				sp.SetInt32("orderId", orderId);
				result = sp.SetResultTransformer(Transformers.AliasToBean(typeof(MM_GetCart)))
					.List<MM_GetCart>();
				session.Close();

			}
			factory.Close();
			return result;

		}

		public IList<MM_GetOrder> MM_GetOrder(int id) {

			IList<MM_GetOrder> result = new List<MM_GetOrder>();

			ISessionFactory factory = config.BuildSessionFactory();
			using (ISession session = factory.OpenSession()) {

				var sp = session.GetNamedQuery("MM_GetOrder");

				sp.SetInt32("id", id);
				result = sp.SetResultTransformer(Transformers.AliasToBean(typeof(MM_GetOrder)))
					.List<MM_GetOrder>();
				session.Close();

			}
			factory.Close();
			return result;

		}


		public IList<MM_GetProducts> MM_GetProducts(int brandId) {

			IList<MM_GetProducts> result = new List<MM_GetProducts>();

			ISessionFactory factory = config.BuildSessionFactory();
			using (ISession session = factory.OpenSession()) {

				var sp = session.GetNamedQuery("MM_GetProducts");
			
				sp.SetInt32("brandId", brandId);
				result = sp.SetResultTransformer(Transformers.AliasToBean(typeof(MM_GetProducts)))
					.List<MM_GetProducts>();
				session.Close();
			}
			factory.Close();
			return result;

		}

		public int MM_NewCart(string orderIp) {

			int result;
			ISessionFactory factory = config.BuildSessionFactory();
			using (ISession session = factory.OpenSession()) {

				var sp = session.GetNamedQuery("MM_NewCart");

				sp.SetString("orderIp", orderIp);
				result = (int)sp.UniqueResult();
				session.Close();

			}
			factory.Close();
			return result;

		}

		public int MM_ShipTo(int order_id, string confirmation, string customer_name, string customer_email, string phone_number, string ship_to_name, string ship_to_address1, string ship_to_address2, string ship_to_city, string ship_to_country, string ship_to_state, string ship_to_zip) {

			ISessionFactory factory = config.BuildSessionFactory();
			using (ISession session = factory.OpenSession()) {

				var sp = session.GetNamedQuery("MM_ShipTo");

				sp.SetInt32("order_id", order_id);
				sp.SetString("confirmation", confirmation);
				sp.SetString("customer_name", customer_name);
				sp.SetString("customer_email", customer_email);
				sp.SetString("phone_number", phone_number);
				sp.SetString("ship_to_name", ship_to_name);
				sp.SetString("ship_to_address1", ship_to_address1);
				sp.SetString("ship_to_address2", ship_to_address2);
				sp.SetString("ship_to_city", ship_to_city);
				sp.SetString("ship_to_country", ship_to_country);
				sp.SetString("ship_to_state", ship_to_state);
				sp.SetString("ship_to_zip", ship_to_zip);
				sp.UniqueResult();
				session.Close();

			}
			factory.Close();
			return 0;

		}


		public int MM_Submit(int order_id) {

			ISessionFactory factory = config.BuildSessionFactory();
			using (ISession session = factory.OpenSession()) {

				var sp = session.GetNamedQuery("MM_Submit");

				sp.SetInt32("order_id", order_id);
				sp.UniqueResult();
				session.Close();

			}
			factory.Close();
			return 0;


		}


		public int MM_UpdateCart(int order_id, int productId, decimal price, int quantity) {

			ISessionFactory factory = config.BuildSessionFactory();
			using (ISession session = factory.OpenSession()) {

				var sp = session.GetNamedQuery("MM_UpdateCart");

				sp.SetInt32("orderId", order_id);
				sp.SetInt32("productId", productId);
				sp.SetDecimal("price", price);
				sp.SetInt32("quantity", quantity);
				sp.UniqueResult();
				session.Close();

			}
			factory.Close();
			return 0;

		}

	}

}
