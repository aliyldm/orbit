package net.bigpoint.darkorbit.fui.builder.xml.creators
{
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.repository.UIInstanceRepository;
   import net.bigpoint.darkorbit.fui.builder.xml.utils.CoreponentDecorator;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.layout.LayoutAutoSizeMode;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   import net.bigpoint.darkorbit.fui.components.text.IText;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   
   public class AbstractCreator
   {
      
      protected static var _coreponentDecorator:CoreponentDecorator;
      
      public static const ATTRIBUTEVALUE_SIZE_WILDCARD:String = "*";
      
      public static const ATTRIBUTEVALUE_SIZE_FILL:String = "fill";
      
      public static const ATTRIBUTEVALUE_SIZE_RELATIVE:String = "%";
      
      public static const ATTRIBUTENAME_WIDTH:String = "width";
      
      public static const ATTRIBUTENAME_HEIGHT:String = "height";
      
      public static const ATTRIBUTENAME_RELATIVE_WIDTH:String = "relativeWidth";
      
      public static const ATTRIBUTENAME_RELATIVE_HEIGHT:String = "relativeHeight";
      
      public static const ATTRIBUTENAME_SIZEHANDLING:String = "sizeHandling";
      
      public static const ATTRIBUTENAME_MODULE_NAME:String = "moduleName";
      
      public static const ATTRIBUTENAME_DEFAULT_LIBRARY:String = "defaultLibrary";
      
      public static const ATTRIBUTENAME_LIBRARY:String = "library";
      
      public static const ATTRIBUTENAME_LIBRARYID:String = "libraryID";
      
      public static const ATTRIBUTEVALUE_CALL_METHOD:String = "call";
      
      protected static var _defaultLibrary:String = null;
      
      protected static const ATTRIBUTE_SEPARATOR:String = ":";
      
      protected static const LOCALIZE_ATTRIBUTE_NAME_AE:String = "localize" + ATTRIBUTE_SEPARATOR;
      
      protected static const LOCALIZE_ATTRIBUTE_NAME_BE:String = "localise" + ATTRIBUTE_SEPARATOR;
      
      protected static const ATTRIBUTE_FORCE_REDRAW:String = "redraw";
      
      protected var attributeToMethodMap:Dictionary = new Dictionary();
      
      protected var _nodeNameToMethodMap:Dictionary = new Dictionary();
      
      public function AbstractCreator()
      {
         super();
         this.initializeAttributeMapping();
      }
      
      public static function getLibrary(param1:XML) : String
      {
         return param1.attribute(AbstractCreator.ATTRIBUTENAME_LIBRARY) || _defaultLibrary;
      }
      
      protected static function get coreponentDecorator() : CoreponentDecorator
      {
         if(_coreponentDecorator == null)
         {
            _coreponentDecorator = new CoreponentDecorator();
         }
         return _coreponentDecorator;
      }
      
      protected static function isBoolean(param1:String) : Boolean
      {
         var _loc2_:String = param1.toLowerCase();
         var _loc3_:Boolean = false;
         if(_loc2_ == "true")
         {
            _loc3_ = true;
         }
         else if(_loc2_ == "false")
         {
            _loc3_ = false;
         }
         return _loc3_;
      }
      
      protected function initializeAttributeMapping() : void
      {
         this.attributeToMethodMap["tooltipData"] = this.handleTooltipDataAttribute;
         this.attributeToMethodMap["text"] = this.handleTextAttribute;
         this.attributeToMethodMap["autoWidthMode"] = this.autoWidthMode;
         this.attributeToMethodMap["autoHeightMode"] = this.autoHeightMode;
         this.attributeToMethodMap["decorator"] = this.handleDecoratorAttribute;
         this.attributeToMethodMap["decorate"] = this.handleDecoratorAttribute;
         this.attributeToMethodMap["name"] = this.handleNameAttribute;
      }
      
      protected function handleNameAttribute(param1:Object, param2:Object) : void
      {
         var _loc3_:Coreponent = param1 as Coreponent;
         if(_loc3_)
         {
            _loc3_.moduleName = UIInstanceRepository.defaultModuleName;
         }
         param1["name"] = String(param2);
      }
      
      protected function handleDecoratorAttribute(param1:Object, param2:Object) : void
      {
         var _loc4_:String = null;
         var _loc3_:Coreponent = param1 as Coreponent;
         if(_loc3_)
         {
            _loc4_ = String(param2);
            if(_loc4_)
            {
               coreponentDecorator.decorate(_loc3_,_loc4_);
            }
         }
      }
      
      protected function handleTooltipDataAttribute(param1:Object, param2:Object) : void
      {
         var _loc4_:String = null;
         var _loc3_:Coreponent = param1 as Coreponent;
         if(_loc3_)
         {
            _loc4_ = String(param2);
            if(_loc4_)
            {
               _loc3_.tooltipData = this.attemptTolocalizeText(_loc4_);
            }
         }
      }
      
      protected function handleTextAttribute(param1:Object, param2:String) : void
      {
         var _loc3_:IText = param1 as IText;
         if(Boolean(_loc3_) && Boolean(param2))
         {
            _loc3_.text = this.attemptTolocalizeText(param2);
         }
      }
      
      protected function autoWidthMode(param1:Object, param2:String) : void
      {
         var _loc3_:Coreponent = param1 as Coreponent;
         if(_loc3_)
         {
            _loc3_.autoSizeMode = LayoutAutoSizeMode.convertAutoWidthMode(param2);
         }
      }
      
      protected function autoHeightMode(param1:Object, param2:String) : void
      {
         var _loc3_:Coreponent = param1 as Coreponent;
         if(_loc3_)
         {
            _loc3_.autoSizeMode = LayoutAutoSizeMode.convertAutoHeigthMode(param2);
         }
      }
      
      protected function mapXMLNodeAttributes(param1:Object, param2:XML) : void
      {
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc3_:XMLList = param2.attributes();
         this.autoMapOwnProperties(param1,_loc3_);
         if(param1 as DisplayObject == null)
         {
            return;
         }
         var _loc4_:Object = param2.attribute(ATTRIBUTENAME_WIDTH);
         var _loc5_:Object = param2.attribute(ATTRIBUTENAME_HEIGHT);
         var _loc6_:Number = Number(_loc4_);
         var _loc7_:Number = Number(_loc5_);
         if(isNaN(_loc6_))
         {
            _loc8_ = String(_loc4_);
         }
         if(isNaN(_loc7_))
         {
            _loc9_ = String(_loc5_);
         }
         if(_loc8_)
         {
            this.handleSpecialAttribute(param1,ATTRIBUTENAME_RELATIVE_WIDTH,_loc8_);
         }
         if(_loc9_)
         {
            this.handleSpecialAttribute(param1,ATTRIBUTENAME_RELATIVE_HEIGHT,_loc9_);
         }
         if(_loc6_ == 0 || isNaN(_loc6_))
         {
            this.setDefaultWidthBasedOnSkin(param1);
         }
         if(_loc7_ == 0 || isNaN(_loc7_))
         {
            this.setDefaultHeightBasedOnSkin(param1);
         }
         if(param2.attribute(ATTRIBUTEVALUE_CALL_METHOD).length() > 0)
         {
            this.callMethod(param1,param2.attribute(ATTRIBUTEVALUE_CALL_METHOD));
         }
         var _loc10_:Coreponent = param1 as Coreponent;
         if(_loc10_ != null)
         {
            if(_loc10_.__shouldRedraw__)
            {
               _loc10_.__redraw__();
            }
         }
      }
      
      private function callMethod(param1:Object, param2:String) : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc3_:Array = param2.replace(")","").split("(");
         var _loc4_:String = _loc3_[0];
         if(param1[_loc4_] is Function)
         {
            if(_loc3_.length > 1 && Boolean(_loc3_[1]))
            {
               _loc5_ = _loc3_[1].split(",");
               _loc6_ = int(_loc5_.length);
               _loc7_ = 0;
               while(_loc7_ < _loc6_)
               {
                  _loc8_ = _loc5_[_loc7_];
                  _loc5_[_loc7_] = ParserUtility.getSimpleProperty(_loc8_);
                  _loc7_++;
               }
            }
            if(_loc5_)
            {
               Function(param1[_loc4_]).apply(null,_loc5_);
            }
            else
            {
               param1[_loc4_]();
            }
         }
      }
      
      protected function autoMapOwnProperties(param1:Object, param2:XMLList) : void
      {
         var _loc3_:XML = null;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         for each(_loc3_ in param2)
         {
            _loc4_ = this.invokeSpecificAttributeHandler(param1,_loc3_);
            if(_loc4_)
            {
               _loc5_ = _loc3_.name();
               _loc6_ = param1 as Object;
               if(_loc6_.hasOwnProperty(_loc5_))
               {
                  _loc7_ = _loc3_.valueOf();
                  _loc7_ = _loc7_ == "true" ? true : (_loc7_ == "false" ? false : _loc7_);
                  _loc6_[_loc5_] = _loc7_;
               }
               else
               {
                  UISystem.log("Couldn´t map attribute {" + _loc5_ + "} with the following value={" + _loc3_.valueOf() + "}",UISystem.LOG_LEVEL_WARN);
               }
            }
         }
      }
      
      protected function mapXMLChildrenToMethodHandler(param1:Object, param2:XML) : void
      {
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc6_:Function = null;
         var _loc3_:XMLList = param2.children();
         for each(_loc4_ in _loc3_)
         {
            _loc5_ = _loc4_.name();
            _loc6_ = this._nodeNameToMethodMap[_loc5_];
            if(_loc6_ != null)
            {
               _loc6_(param1,_loc4_);
            }
         }
      }
      
      protected function handleSpecialAttribute(param1:Object, param2:String, param3:String) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         if(param3.indexOf(ATTRIBUTEVALUE_SIZE_RELATIVE) != -1)
         {
            _loc4_ = param3.indexOf(ATTRIBUTEVALUE_SIZE_RELATIVE);
            _loc5_ = Number(param3.substr(0,_loc4_));
            param1[param2] = _loc5_;
            param1[ATTRIBUTENAME_SIZEHANDLING] = Coreponent.SIZE_RELATIVE;
         }
         else
         {
            switch(param3)
            {
               case ATTRIBUTEVALUE_SIZE_WILDCARD:
               case ATTRIBUTEVALUE_SIZE_FILL:
                  param1[ATTRIBUTENAME_SIZEHANDLING] = Coreponent.SIZE_FILL;
            }
         }
      }
      
      protected function setDefaultWidthBasedOnSkin(param1:Object) : void
      {
         var _loc2_:ISkin = null;
         var _loc3_:Rectangle = null;
         var _loc4_:DisplayObject = null;
         if(param1 as Coreponent != null)
         {
            _loc2_ = (param1 as Coreponent).skin;
            if(_loc2_)
            {
               _loc3_ = _loc2_.measureRawSkinSize;
               param1[ATTRIBUTENAME_WIDTH] = _loc3_.width;
            }
         }
         else if(param1 as DisplayObject != null)
         {
            _loc4_ = param1 as DisplayObject;
            if(_loc4_)
            {
               if(_loc4_.width > 0)
               {
                  param1[ATTRIBUTENAME_WIDTH] = _loc4_.width;
               }
            }
         }
         else
         {
            this.traceSizeAssignError(param1);
         }
      }
      
      protected function setDefaultHeightBasedOnSkin(param1:Object) : void
      {
         var _loc2_:ISkin = null;
         var _loc3_:Rectangle = null;
         var _loc4_:DisplayObject = null;
         if(param1 as Coreponent != null)
         {
            _loc2_ = (param1 as Coreponent).skin;
            if(_loc2_)
            {
               _loc3_ = _loc2_.measureRawSkinSize;
               param1[ATTRIBUTENAME_HEIGHT] = _loc3_.height;
            }
         }
         else if(param1 as DisplayObject != null)
         {
            _loc4_ = param1 as DisplayObject;
            if(_loc4_)
            {
               if(_loc4_.height > 0)
               {
                  param1[ATTRIBUTENAME_HEIGHT] = _loc4_.height;
               }
            }
         }
         else
         {
            this.traceSizeAssignError(param1);
         }
      }
      
      private function traceSizeAssignError(param1:Object) : void
      {
         var _loc2_:String = "UNKNOW";
         if(param1)
         {
            if(param1.hasOwnProperty("name"))
            {
               _loc2_ = param1["name"];
            }
         }
         UISystem.log("Couldn´t assign default size. Perhaps you didn´t assign a skin to the current component with the name=[" + _loc2_ + " ]");
      }
      
      protected function invokeSpecificAttributeHandler(param1:Object, param2:XML) : Boolean
      {
         var _loc3_:String = param2.name();
         if(this.attributeToMethodMap[_loc3_])
         {
            this.attributeToMethodMap[_loc3_](param1,param2.valueOf());
            return false;
         }
         return true;
      }
      
      protected function attemptTolocalizeText(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc3_:String = param1;
         _loc2_ = param1.indexOf(LOCALIZE_ATTRIBUTE_NAME_AE);
         if(_loc2_ < 0)
         {
            _loc2_ = param1.indexOf(LOCALIZE_ATTRIBUTE_NAME_BE);
         }
         if(_loc2_ >= 0)
         {
            _loc4_ = param1.split(ATTRIBUTE_SEPARATOR)[1];
            _loc5_ = null;
            if(param1.split(ATTRIBUTE_SEPARATOR).length >= 3)
            {
               _loc5_ = param1.split(ATTRIBUTE_SEPARATOR)[2];
            }
            return UISystem.localize(_loc4_,_loc5_);
         }
         return _loc3_;
      }
   }
}

