using System;
using System.Collections.Generic;
using monomart.Models.Domain;

namespace monomart.Models
{
	public interface IMonomartEntities
	{

		int MM_DelCart(int orderId);
		IList<MM_GetCart> MM_GetCart(int orderId);
		IList<MM_GetBrand> MM_GetBrand(int orderId);
		IList<MM_GetOrder> MM_GetOrder(int id);
		IList<MM_GetProducts> MM_GetProducts(int brandId);
		int MM_NewCart(string orderIp);
		int MM_ShipTo(int order_id, string confirmation, string customer_name, string customer_email, string phone_number, string ship_to_name, string ship_to_address1, string ship_to_address2, string ship_to_city, string ship_to_country, string ship_to_state, string ship_to_zip);
		int MM_Submit(int order_id);
		int MM_UpdateCart(int order_id, int productId, decimal price, int quantity);


	}
}