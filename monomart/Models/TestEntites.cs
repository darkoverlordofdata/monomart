using System;
using System.Collections.Generic;
using monomart.Models.Domain;


namespace monomart.Models
{

	public class TestEntites : IMonomartEntities
	{
		public int MM_DelCart(int orderId) {
			return 0;
		}

		public IList<MM_GetBrand> MM_GetBrand(int orderId) {

			return new List<MM_GetBrand> {
				new MM_GetBrand {id=1, 
					name="Test Brand"}

			};
				
		}

		public IList<MM_GetCart> MM_GetCart(int orderId) {
			
			return new List<MM_GetCart>();
		}

		public IList<MM_GetOrder> MM_GetOrder(int id) {

			return new List<MM_GetOrder>();
		}

		public IList<MM_GetProducts> MM_GetProducts(int brandId) {

			return new List<MM_GetProducts> {
				new MM_GetProducts {id=1, 
					brand="Test Brand", 
					name="Senna Leaf",
					size="30 tea bags",
					upc="726016005258",
					price=2.91m,
					ingredients="Senna Leaf",
					servings="1 capsule",
					servingsize="90",
					image="ais-283_1.jpg"}

			};

		}

		public int MM_NewCart(string orderIp) {
			return 0;
		}

		public int MM_ShipTo(int order_id, string confirmation, string customer_name, string customer_email, string phone_number, string ship_to_name, string ship_to_address1, string ship_to_address2, string ship_to_city, string ship_to_country, string ship_to_state, string ship_to_zip) {
			return 0;
		}

		public int MM_Submit(int order_id) {
			return 0;
		}

		public int MM_UpdateCart(int order_id, int productId, decimal price, int quantity) {
			return 0;
		}
	}
}

