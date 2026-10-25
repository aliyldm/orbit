package net.bigpoint.darkorbit.utils
{
   public class XMLUtils
   {
      
      public function XMLUtils()
      {
         super();
      }
      
      public static function clean(param1:XML) : XML
      {
         var _loc2_:String = param1.toString();
         var _loc3_:RegExp = /(xmlns|xsi)[^"]*"[^"]*"/gi;
         _loc2_ = _loc2_.replace(_loc3_,"");
         return new XML(_loc2_);
      }
      
      public static function getChildByAttributeName(param1:XMLList, param2:String, param3:String) : XMLList
      {
         var _loc6_:XML = null;
         var _loc8_:int = 0;
         var _loc4_:XMLList = param1;
         var _loc5_:int = _loc4_.length();
         var _loc7_:XMLList = new XMLList();
         var _loc9_:int = 0;
         while(_loc9_ < _loc5_)
         {
            _loc6_ = _loc4_[_loc9_];
            if(_loc6_.attribute(param2) == param3)
            {
               _loc7_[_loc8_] = _loc6_;
               _loc8_++;
            }
            _loc9_++;
         }
         return _loc7_;
      }
      
      public static function getFirstChildrenByAttributeName(param1:XMLList, param2:String, param3:String) : XML
      {
         var _loc6_:XML = null;
         var _loc7_:XML = null;
         var _loc4_:XMLList = param1.children();
         var _loc5_:int = _loc4_.length();
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_)
         {
            _loc6_ = _loc4_[_loc8_];
            if(_loc6_.children().length() > 0)
            {
               _loc7_ = getFirstChildrenByAttributeName(_loc6_.children(),param2,param3);
               if(_loc7_)
               {
                  return _loc7_;
               }
            }
            if(_loc6_.attribute(param2) == param3)
            {
               return _loc6_;
            }
            _loc8_++;
         }
         return null;
      }
      
      public static function getChildrenTheOldWay(param1:XML, param2:String) : XMLList
      {
         var _loc3_:Array = param2.split(".");
         var _loc4_:int = int(_loc3_.length);
         var _loc5_:XMLList = XMLList(param1);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_)
         {
            _loc5_ = _loc5_.child(_loc3_[_loc6_]);
            _loc6_++;
         }
         return _loc5_;
      }
      
      public static function resolveReferences(param1:XML) : XML
      {
         var _loc5_:XML = null;
         var _loc6_:XMLList = null;
         var _loc7_:XML = null;
         var _loc8_:XML = null;
         var _loc9_:String = null;
         var _loc10_:XML = null;
         param1 = param1.copy();
         var _loc2_:XMLList = param1.descendants("reference");
         var _loc3_:int = _loc2_.length();
         var _loc4_:* = int(_loc3_ - 1);
         while(_loc4_ >= 0)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc6_ = selectNode(param1,_loc5_.attribute("selector"),false);
            for each(_loc7_ in _loc6_)
            {
               _loc8_ = processReference(_loc7_,_loc5_);
               _loc9_ = _loc5_.attribute("children");
               if(_loc9_ === "false")
               {
                  _loc5_.parent().appendChild(_loc8_);
               }
               else
               {
                  for each(_loc10_ in _loc8_.children())
                  {
                     _loc5_.parent().appendChild(_loc10_);
                  }
               }
            }
            delete _loc5_.parent().children()[_loc5_.childIndex()];
            _loc4_--;
         }
         return param1;
      }
      
      private static function processReference(param1:XML, param2:XML) : XML
      {
         var _loc4_:XMLList = null;
         var _loc5_:XML = null;
         var _loc7_:XML = null;
         var _loc8_:XMLList = null;
         var _loc9_:XML = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:XML = null;
         var _loc3_:XML = param1.copy();
         var _loc6_:XMLList = param2.child("replace");
         for each(_loc7_ in _loc6_)
         {
            _loc4_ = selectNode(_loc3_,_loc7_.attribute("selector"),false);
            for each(_loc5_ in _loc4_)
            {
               _loc10_ = _loc7_.attribute("attributes").toString().split(",");
               _loc11_ = _loc7_.attribute("values").toString().split(",");
               _loc12_ = Math.min(_loc11_.length,_loc10_.length);
               _loc13_ = 0;
               while(_loc13_ < _loc12_)
               {
                  _loc5_[_loc10_[_loc13_]] = _loc11_[_loc13_];
                  _loc13_++;
               }
            }
         }
         _loc8_ = param2.child("append");
         for each(_loc9_ in _loc8_)
         {
            _loc4_ = selectNode(_loc3_,_loc9_.attribute("selector"),false);
            for each(_loc5_ in _loc4_)
            {
               for each(_loc14_ in _loc9_.children())
               {
                  _loc5_.appendChild(_loc14_.copy());
               }
            }
         }
         return _loc3_;
      }
      
      private static function selectNode(param1:XML, param2:String, param3:Boolean) : XMLList
      {
         var _loc12_:XML = null;
         var _loc13_:String = null;
         if(param2 === "this")
         {
            return XMLList(param1);
         }
         var _loc4_:Array = param2.split("WHERE");
         var _loc5_:Array = String(_loc4_[0]).split(">");
         var _loc6_:Condition = new Condition(_loc4_[1]);
         var _loc7_:int = int(_loc5_.length);
         var _loc8_:XMLList = XMLList(param1);
         var _loc9_:int = 0;
         while(_loc9_ < _loc7_)
         {
            _loc13_ = String(_loc5_[_loc9_]).replace(" ","");
            _loc8_ = _loc8_.child(_loc13_);
            _loc9_++;
         }
         var _loc10_:XMLList = new XMLList();
         var _loc11_:* = 0;
         for each(_loc12_ in _loc8_)
         {
            if(_loc6_.check(_loc12_))
            {
               var _loc16_:Number;
               _loc10_[_loc16_ = _loc11_++] = param3 ? _loc12_.children() : _loc12_;
            }
         }
         return _loc10_;
      }
      
      public static function unpretty(param1:XML) : XML
      {
         var _loc2_:Boolean = Boolean(XML.prettyPrinting);
         XML.prettyPrinting = false;
         param1 = new XML(param1.toXMLString());
         XML.prettyPrinting = _loc2_;
         return param1;
      }
   }
}

class Condition
{
   
   private var _condition:String;
   
   public function Condition(param1:String)
   {
      super();
      this._condition = param1 ? param1.replace(" ","") : "*";
   }
   
   public function check(param1:XML) : Boolean
   {
      var _loc2_:Array = null;
      var _loc3_:String = null;
      var _loc4_:String = null;
      if(this._condition == "*")
      {
         return true;
      }
      _loc2_ = String(this._condition).split("==");
      _loc3_ = String(_loc2_[0]);
      _loc4_ = String(_loc2_[1]);
      return String(param1.attribute(_loc3_)) == _loc4_;
   }
}
