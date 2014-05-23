using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;
using monomart.Models;
using monomart.Models.Domain;
using MvcPaging;

namespace monomart.Controllers
{
	public class CatalogController : Controller
	{
		protected IMonomartEntities storeDB;

		public CatalogController()
			: this(new MonomartEntities()) {
		}

		public CatalogController(IMonomartEntities repository) {
			storeDB = repository;
			ViewBag.Title = "Mono-Mart";
			ViewBag.MenuHome = "";
			ViewBag.MenuCatalog = "active";
			ViewBag.MenuCart = "";
			ViewBag.MenuCheckout = "";
		}

		[HttpGet]
		public ActionResult Index(string id, int? page)
		{

			int brand_id = Convert.ToInt32(id);

			if (brand_id > 0)
			{
				IList<MM_GetBrand> brands = storeDB.MM_GetBrand(brand_id);
				if (brands.Count == 0) {
					ViewBag.BrandName = "???";
				}
				else {
					MM_GetBrand brand = (MM_GetBrand)brands[0];
					ViewBag.BrandName = brand.name;
				}

			}
			else
			{
				ViewBag.BrandName = "All Brands";
			}
			ViewBag.Confirmation = ViewBag.BrandName;
			int pageSize = 6;
			int pageNumber = page.HasValue ? page.Value - 1 : 0;

			var data = storeDB.MM_GetProducts(brand_id).ToPagedList(pageNumber, pageSize);

			return View(data);

		}

	}
}

