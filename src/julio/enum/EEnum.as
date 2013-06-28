package julio.enum
{
	import flash.utils.describeType;

	public class EEnum
	{
		private static var _lastId:uint = 0;
		private var _id:uint = 0;
		private var _name :String = null;
		
/*		private static var _enumCreated:Boolean = false;
		
		// magic happens here, the static code block
		{
			_enumCreated = true;
		}
		
		public function EEnum()
		{
			if (_enumCreated)
				throw new Error("The enum is already created.");
		}
*/
		public function get name() :String
		{	return _name;	}
		
		public function get id() :uint
		{	return _id;	}
		
		public function toString() :String // override
		{	return name;	}
		
		protected static function initEnum(i_type :*) :void
		{
			var type :XML = flash.utils.describeType(i_type);
			for each (var constant :XML in type.constant)
			{
				var enumConstant :EEnum = i_type[constant.@name];

				// if 'text' is already initialized, then we're probably
				// calling initEnum() on the same type twice by accident,
				// likely a copy-paste bonehead mistake.
				if (enumConstant.name != null)
				{
					throw new Error("Can't initialize '" + i_type + "' twice");
				}

				// if the types don't match then probably have another
				// copy-paste error.
				var enumConstantObj :* = enumConstant;
				if (enumConstantObj.constructor != i_type)
				{
					throw new Error(
						"Constant type '" + enumConstantObj.constructor + "' " +
						"does not match its enum class '" + i_type + "'");
				}

				enumConstant._name = constant.@name;
				enumConstant._id = _lastId;
				_lastId++;
			}
		}
	}
}
