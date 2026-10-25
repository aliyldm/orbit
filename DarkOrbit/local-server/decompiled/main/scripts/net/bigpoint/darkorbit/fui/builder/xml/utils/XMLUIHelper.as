package net.bigpoint.darkorbit.fui.builder.xml.utils
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.MappingInstanceNames;
   import net.bigpoint.darkorbit.fui.builder.repository.XMLUITemplateRepository;
   
   public class XMLUIHelper
   {
      
      private static const SEARCH_ATTRIBUTE__NAME:String = "name";
      
      public function XMLUIHelper()
      {
         super();
      }
      
      public static function __template__(param1:XML) : XML
      {
         var _loc2_:String = param1.attribute(MappingInstanceNames.TEMPLATE);
         if(_loc2_)
         {
            return overridesTemplate(param1,_loc2_);
         }
         return param1;
      }
      
      public static function overridesTemplate(param1:XML, param2:String) : XML
      {
         var _loc6_:XML = null;
         var _loc7_:String = null;
         var _loc8_:XML = null;
         var _loc9_:XMLList = null;
         var _loc10_:uint = 0;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:XML = null;
         var _loc14_:String = null;
         var _loc15_:XML = null;
         var _loc16_:XMLList = null;
         var _loc17_:uint = 0;
         var _loc18_:int = 0;
         var _loc19_:String = null;
         var _loc20_:XML = null;
         var _loc21_:String = null;
         var _loc22_:XML = null;
         var _loc3_:XML = XMLUITemplateRepository.getInstance().getTemplateByName(param2) as XML;
         if(_loc3_ == null)
         {
            return null;
         }
         var _loc4_:Dictionary = new Dictionary();
         var _loc5_:XMLList = param1..@name;
         for each(_loc6_ in _loc5_)
         {
            _loc12_ = _loc6_.toString();
            _loc4_[_loc12_] = null;
         }
         for(_loc7_ in _loc4_)
         {
            _loc13_ = getXMLElementByAttributeName(_loc3_,_loc7_);
            if(_loc13_)
            {
               _loc4_[_loc7_] = _loc13_;
            }
         }
         for each(_loc8_ in _loc4_)
         {
            if(_loc8_ != null)
            {
               _loc14_ = _loc8_.@name;
               _loc15_ = getXMLElementByAttributeName(param1,_loc14_);
               if(_loc15_ != null)
               {
                  _loc16_ = _loc15_.attributes();
                  _loc17_ = uint(_loc16_.length());
                  _loc18_ = 0;
                  while(_loc18_ < _loc17_)
                  {
                     _loc19_ = _loc16_[_loc18_].name();
                     _loc8_[_loc19_] = _loc16_[_loc18_].valueOf();
                     _loc18_++;
                  }
               }
            }
            else
            {
               UISystem.log("MERGE ERROR !!! ",UISystem.LOG_LEVEL_WARN);
            }
         }
         _loc9_ = param1.children();
         _loc10_ = uint(_loc9_.length());
         _loc11_ = 0;
         while(_loc11_ < _loc10_)
         {
            _loc20_ = _loc9_[_loc11_];
            _loc21_ = _loc20_.attribute("name");
            _loc22_ = getXMLElementByAttributeName(_loc3_,_loc21_);
            if(_loc22_ == null)
            {
               _loc3_.appendChild(_loc20_);
            }
            _loc11_++;
         }
         return _loc3_;
      }
      
      protected static function getXMLElementByAttributeName(param1:XML, param2:String) : XML
      {
         var xmlList:XMLList = null;
         var filtered:XMLList = null;
         var node:XML = param1;
         var searchValue:String = param2;
         xmlList = node..*.(hasOwnProperty("@name"));
         filtered = xmlList.(attribute(SEARCH_ATTRIBUTE__NAME) == searchValue);
         if(filtered == null)
         {
            return null;
         }
         if(filtered.length() == 1)
         {
            return filtered[0];
         }
         UISystem.log("Error.Couldn´t find node for name = " + searchValue,UISystem.LOG_LEVEL_WARN);
         return null;
      }
   }
}

