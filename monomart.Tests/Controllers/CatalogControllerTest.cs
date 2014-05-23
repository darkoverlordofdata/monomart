using NUnit.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.Mvc;
using monomart;
using monomart.Controllers;
using monomart.Models;

namespace monomart.Tests
{
	[TestFixture()]
	public class CatalogControllerTest
	{
		[Test()]
		public void Index()
		{
			// Arrange
			CatalogController controller = new CatalogController(new TestEntites());

			// Act
			ViewResult result = controller.Index("1", 1) as ViewResult;

			// Assert
			Assert.AreEqual("Test Brand", result.ViewBag.BrandName);
		}
	}
}
