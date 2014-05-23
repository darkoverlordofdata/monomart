using System;
using System.Collections.Generic;

namespace monomart.Models
{
	public interface IPagable<T>
	{
		int PageNumber { get;}
		int PageSize {get;}
		int CountAll {get;}
		T this[int index] { get; }
	}

	public class Pageable<T> : IPagable<T>
	{

		protected IList<T> Data;

		public Pageable(IList<T> data, int count, int pageNumber, int pageSize) {

			Data = data;
			CountAll = count;
			PageNumber = pageNumber;
			PageSize = pageSize;

		}

		public int PageNumber { get; protected set; }
		public int PageSize { get; protected set; }
		public int CountAll { get; protected set; }
		public T this[int index] { 
			get {return Data[index];}
		}

	}
}

