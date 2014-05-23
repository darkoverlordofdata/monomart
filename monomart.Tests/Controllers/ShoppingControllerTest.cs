using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using monomart;
using monomart.Controllers;

namespace monomart.Tests
{
	[TestFixture()]
	public class ShoppingControllerTest
	{
		[Test()]
		public void Index()
		{
			// Arrange
			ShoppingController controller = new ShoppingController();

			// Act
			ViewResult result = controller.Index() as ViewResult;

			// Assert
			Assert.AreEqual("Mono-Mart", result.ViewBag.Title);
		}
		[Test()]
		public void Checkout()
		{
			// Arrange
			ShoppingController controller = new ShoppingController();

			// Act
			ViewResult result = controller.Checkout() as ViewResult;

			// Assert
			Assert.AreEqual("active", result.ViewBag.MenuCheckout);
		}
	}
}
