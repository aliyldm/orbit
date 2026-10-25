package net.bigpoint.darkorbit.mvc.common.utils
{
   import avmplus.getQualifiedClassName;
   import flash.utils.describeType;
   import flash.utils.getDefinitionByName;
   
   public class ClassUtils
   {
      
      private static const describeTypeLookup:Object = {};
      
      public function ClassUtils()
      {
         super();
      }
      
      public static function getClass(param1:Object) : Class
      {
         return Class(getDefinitionByName(getQualifiedClassName(param1)));
      }
      
      public static function getAllStaticFields(param1:Class, param2:Boolean = false) : Array
      {
         var _loc6_:XML = null;
         var _loc3_:XML = getDescribeType(param1,param2);
         var _loc4_:XMLList = _loc3_.child("constant");
         var _loc5_:Array = [];
         for each(_loc6_ in _loc4_)
         {
            _loc5_.push(_loc6_.attribute("name").toString());
         }
         return _loc5_;
      }
      
      private static function getDescribeType(param1:Class, param2:Boolean = false) : XML
      {
         if(!describeTypeLookup[param1])
         {
            if(param2)
            {
               return describeTypeLookup[param1] = describeType(param1);
            }
            return describeType(param1);
         }
         return describeTypeLookup[param1];
      }
      
      public static function getAllFields(param1:Class, param2:Boolean = false) : Array
      {
         var _loc6_:XML = null;
         var _loc3_:XML = getDescribeType(param1,param2);
         var _loc4_:XMLList = _loc3_.child("constant");
         var _loc5_:Array = [];
         for each(_loc6_ in _loc4_)
         {
            _loc5_.push(_loc6_.attribute("name").toString());
         }
         return _loc5_;
      }
   }
}

