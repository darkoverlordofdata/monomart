using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Ajax;

namespace monomart.Controllers
{
	public class HomeController : Controller
	{
		public HomeController()
		{

			ViewBag.Title = "Mono-Mart";
			ViewBag.MenuHome = "";
			ViewBag.MenuCatalog = "active";
			ViewBag.MenuCart = "";
			ViewBag.MenuCheckout = "";

		}

		public ActionResult Index(string confirm = "")
		{
			ViewBag.MenuHome = "active";
			ViewBag.Confirmation = confirm;
			return View();

		}
	}
}

