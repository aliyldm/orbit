package net.bigpoint.darkorbit.delete_in_eic
{
   import flash.utils.getQualifiedClassName;
   import net.bigpoint.darkorbit.items.item.attributes.BoosterAttributes;
   import org.as3commons.lang.ClassUtils;
   
   public class ItemWildcardReplacer
   {
      
      private static const class2translation:Object = {};
      
      class2translation[ClassUtils.getFullyQualifiedName(BoosterAttributes)] = translateBoosters;
      
      public function ItemWildcardReplacer()
      {
         super();
      }
      
      public static function replace(param1:ItemVO, param2:String) : String
      {
         var _loc3_:String = getQualifiedClassName(param1.item.attributes);
         var _loc4_:Function = class2translation[_loc3_];
         if(_loc4_ != null)
         {
            return _loc4_(param1,param2);
         }
         return param2;
      }
      
      private static function translateBoosters(param1:ItemVO, param2:String) : String
      {
         var _loc3_:BoosterAttributes = param1.item.attributes as BoosterAttributes;
         return param2.replace("%BOOSTERVALUE%",_loc3_.boostList[0].factor).replace("%HOURS%",_loc3_.hours).replace("%AREABOOSTERVALUE%",_loc3_.boostList[0].areaFactor);
      }
   }
}

