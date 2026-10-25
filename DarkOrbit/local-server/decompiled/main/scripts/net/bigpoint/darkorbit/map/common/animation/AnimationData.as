package net.bigpoint.darkorbit.map.common.animation
{
   import com.greensock.easing.EaseLookup;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   
   public class AnimationData
   {
      
      public static const EXCLUDE_TWEEN_ATTRIBUTE_LIST:Dictionary = getExcludeListForTweens();
      
      private static const TARGET:String = "target";
      
      private static const TIME:String = "duration";
      
      private static const EASE:String = "ease";
      
      private static const TWEEN:String = "tween";
      
      private static const AUTO_PLAY:String = "autoPlay";
      
      private static const REPEAT:String = "repeat";
      
      private static const YOYO:String = "yoyo";
      
      private static const CURRENT_TIME:String = "currentTime";
      
      private static const ANIMATION:String = "animation";
      
      private var _repeat:int;
      
      private var _yoyo:Boolean;
      
      private var _autoPlay:Boolean;
      
      private var _children:Vector.<Object>;
      
      private var _parallel:Boolean;
      
      private var _currentTime:Number;
      
      public function AnimationData(param1:int, param2:Boolean, param3:Boolean, param4:Boolean, param5:Vector.<Object>, param6:Number = 0)
      {
         super();
         this._parallel = param4;
         this._children = param5;
         this._autoPlay = param3;
         this._yoyo = param2;
         this._repeat = param1;
         this._currentTime = param6;
      }
      
      public static function parse(param1:XML) : AnimationData
      {
         var _loc2_:XMLList = param1.children();
         var _loc3_:int = int(String(param1.attribute(REPEAT)));
         var _loc4_:Boolean = ParserUtility.parseBooleanFromString(param1.attribute(YOYO));
         var _loc5_:Number = Number(String(param1.attribute(CURRENT_TIME)));
         var _loc6_:Boolean = true;
         if(param1.attribute(AUTO_PLAY).length() > 0)
         {
            _loc6_ = ParserUtility.parseBooleanFromString(param1.attribute(AUTO_PLAY));
         }
         var _loc7_:Boolean = String(param1.@sequence) != "true";
         return new AnimationData(_loc3_,_loc4_,_loc6_,_loc7_,createChildrenVOs(_loc2_),_loc5_);
      }
      
      private static function createChildrenVOs(param1:XMLList) : Vector.<Object>
      {
         var _loc3_:XML = null;
         var _loc2_:Vector.<Object> = new Vector.<Object>();
         for each(_loc3_ in param1)
         {
            switch(_loc3_.localName())
            {
               case ANIMATION:
                  _loc2_.push(parse(_loc3_));
                  break;
               case TWEEN:
                  _loc2_.push(buildTweenVO(_loc3_));
            }
         }
         return _loc2_;
      }
      
      private static function buildTweenVO(param1:XML) : TweenData
      {
         var _loc4_:XML = null;
         var _loc5_:Number = NaN;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc2_:XMLList = param1.attributes();
         var _loc3_:Object = {};
         for each(_loc4_ in _loc2_)
         {
            _loc6_ = _loc4_.name();
            if(!EXCLUDE_TWEEN_ATTRIBUTE_LIST[_loc6_])
            {
               _loc7_ = _loc4_.toString();
               if(_loc6_ == EASE)
               {
                  _loc7_ = EaseLookup.find(_loc4_.toString());
               }
               else
               {
                  _loc7_ = parseVariable(_loc4_.toString());
                  _loc7_ = _loc7_.hasOwnProperty(_loc6_) ? _loc7_[_loc6_] : _loc7_;
               }
               if(_loc6_ == "scale")
               {
                  _loc3_.scaleX = _loc3_.scaleY = _loc3_.scaleZ = _loc7_;
               }
               else
               {
                  _loc3_[_loc6_] = _loc7_;
               }
            }
         }
         _loc5_ = Number(String(param1.attribute(CURRENT_TIME)));
         return new TweenData(String(param1.attribute(TARGET)),parseVariable(param1.attribute(TIME).toString()) as Number || 0.00001,_loc3_,_loc5_);
      }
      
      public static function parseVariable(param1:String) : Object
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Number = NaN;
         var _loc8_:String = null;
         if(param1 == null)
         {
            return param1;
         }
         if(param1.indexOf("random(") == 0)
         {
            _loc2_ = param1.slice(7,param1.length - 1).split(",");
            _loc3_ = 0;
            _loc4_ = 1;
            if(_loc2_.length == 1)
            {
               _loc4_ = Number(_loc2_[0]);
            }
            else if(_loc2_.length == 2)
            {
               _loc3_ = Number(_loc2_[0]);
               _loc4_ = Number(_loc2_[1]);
            }
            if(isNaN(_loc3_))
            {
               _loc3_ = 0;
            }
            if(isNaN(_loc4_))
            {
               _loc4_ = 1;
            }
            return _loc3_ + Math.random() * (_loc4_ - _loc3_);
         }
         if(param1.indexOf("randomPick(") == 0)
         {
            _loc5_ = param1.slice(11,param1.length - 1).split(",");
            return _loc5_[int(Math.random() * _loc5_.length)];
         }
         if(param1.indexOf("randomNumberPick(") == 0)
         {
            _loc6_ = param1.slice(17,param1.length - 1).split(",");
            return Number(_loc6_[int(Math.random() * _loc6_.length)]);
         }
         switch(param1)
         {
            case "true":
               return true;
            case "false":
               return false;
            default:
               if(!isNaN(Number(param1)))
               {
                  return Number(param1);
               }
               try
               {
                  return JSON.parse(param1);
               }
               catch(error:Error)
               {
               }
               _loc8_ = param1;
               if(_loc8_.indexOf("\'") == 0)
               {
                  _loc8_ = _loc8_.slice(1);
               }
               if(_loc8_.lastIndexOf("\'") == _loc8_.length - 1)
               {
                  _loc8_ = _loc8_.slice(0,_loc8_.length - 1);
               }
               return _loc8_;
         }
      }
      
      private static function getExcludeListForTweens() : Dictionary
      {
         var _loc1_:Dictionary = new Dictionary();
         _loc1_[TARGET] = true;
         _loc1_[TIME] = true;
         _loc1_[CURRENT_TIME] = true;
         return _loc1_;
      }
      
      public function get repeat() : int
      {
         return this._repeat;
      }
      
      public function get yoyo() : Boolean
      {
         return this._yoyo;
      }
      
      public function get children() : Vector.<Object>
      {
         return this._children;
      }
      
      public function get autoPlay() : Boolean
      {
         return this._autoPlay;
      }
      
      public function get parallel() : Boolean
      {
         return this._parallel;
      }
      
      public function get currentTime() : Number
      {
         return this._currentTime;
      }
   }
}

