package net.bigpoint.darkorbit.gui.windows.simpleWindow
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.gui.BarState;
   import net.bigpoint.darkorbit.gui.BarStatesCollection;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.InfoContainer;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.InfoField;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.model.vo.FeatureWindowVO;
   
   public class SimpleWindowContentBuilder
   {
      
      private static const XMLATTRIBUTE__ALIGN_HORIZONTAL:String = "horizontal";
      
      private static const XMLATTRIBUTE__NO_ALIGN:String = "noAlign";
      
      public function SimpleWindowContentBuilder()
      {
         super();
      }
      
      public static function addWindowContent(param1:GuiManager, param2:SimpleWindow, param3:FeatureWindowVO, param4:SWFFinisher) : void
      {
         if(param2 == null)
         {
            return;
         }
         var _loc5_:XMLList = param3.definition.infoFieldContainers;
         var _loc6_:XMLList = param3.definition.simpleContainers;
         buildInfoFieldContainers(param2,_loc5_,param1,param4);
         buildSimpleContainers(param2,_loc6_,param1);
      }
      
      private static function buildSimpleContainers(param1:SimpleWindow, param2:XMLList, param3:GuiManager) : void
      {
         var _loc4_:int = 0;
         var _loc5_:XML = null;
         var _loc6_:SimpleContainer = null;
         for each(_loc5_ in param2)
         {
            _loc4_ = int(_loc5_.@id);
            _loc6_ = new SimpleContainer(param3,_loc4_);
            if(_loc5_.@x.length() > 0)
            {
               _loc6_.x = int(_loc5_.@x);
            }
            if(_loc5_.@y.length() > 0)
            {
               _loc6_.y = int(_loc5_.@y);
            }
            param1.addContainer(_loc6_);
         }
      }
      
      private static function buildInfoFieldContainers(param1:SimpleWindow, param2:XMLList, param3:GuiManager, param4:SWFFinisher) : int
      {
         var _loc5_:int = 0;
         var _loc6_:XML = null;
         var _loc7_:InfoContainer = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:XML = null;
         var _loc12_:int = 0;
         var _loc13_:Bitmap = null;
         var _loc14_:String = null;
         var _loc15_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:BarState = null;
         var _loc18_:int = 0;
         var _loc19_:InfoField = null;
         var _loc20_:String = null;
         var _loc21_:String = null;
         for each(_loc6_ in param2)
         {
            _loc5_ = int(_loc6_.@id);
            _loc7_ = new InfoContainer(param3,_loc5_);
            _loc8_ = 100;
            _loc9_ = SimpleContainer.ALIGN_VERTICAL;
            if(_loc6_.@align.length() > 0)
            {
               if(_loc6_.@align == XMLATTRIBUTE__ALIGN_HORIZONTAL)
               {
                  _loc9_ = SimpleContainer.ALIGN_HORIZONTAL;
               }
               else if(_loc6_.@align == XMLATTRIBUTE__NO_ALIGN)
               {
                  _loc9_ = SimpleContainer.NO_ALIGN;
               }
            }
            if(_loc6_.@x_0.length() > 0 && _loc6_.@y_0.length() > 0)
            {
               _loc7_.addPredefinedPosition(new Point(_loc6_.@x_0,_loc6_.@y_0));
            }
            if(_loc6_.@x_1.length() > 0 && _loc6_.@y_1.length() > 0)
            {
               _loc7_.addPredefinedPosition(new Point(_loc6_.@x_1,_loc6_.@y_1));
            }
            if(_loc6_.@textFieldWidth.length() > 0)
            {
               _loc8_ = int(_loc6_.@textFieldWidth);
            }
            for each(_loc11_ in _loc6_.infoField)
            {
               _loc12_ = int(_loc11_.@id);
               if(_loc11_.@linkage.length() > 0)
               {
                  _loc20_ = _loc11_.@linkage;
                  param4 = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
                  _loc13_ = param4.getEmbeddedBitmap(_loc20_);
               }
               else
               {
                  _loc13_ = new Bitmap(new BitmapData(24,24,true,0));
               }
               _loc14_ = null;
               if(_loc11_.@languageKey.length() > 0)
               {
                  _loc14_ = _loc11_.@languageKey;
               }
               _loc15_ = null;
               if(_loc11_.@bar.length() > 0)
               {
                  _loc21_ = _loc11_.@bar;
                  _loc15_ = _loc21_.split(",");
               }
               _loc16_ = InfoField.MODE_BAR;
               _loc17_ = BarStatesCollection.getBarState(_loc12_);
               if(_loc17_ != null)
               {
                  _loc16_ = _loc17_.stateID;
               }
               if(_loc11_.@width.length() > 0)
               {
                  _loc10_ = int(_loc11_.@width);
               }
               else
               {
                  _loc10_ = -1;
               }
               _loc18_ = 1;
               if(_loc11_.@lineCount.length() > 0)
               {
                  _loc18_ = int(_loc11_.@lineCount);
               }
               _loc19_ = new InfoField(param3,_loc12_,_loc13_,_loc10_,_loc15_,_loc14_,_loc16_,_loc18_);
               switch(_loc12_)
               {
                  case SimpleElement.TYPE_JUMP_VOUCHERS:
                  case SimpleElement.TYPE_LEVEL:
                  case SimpleElement.TYPE_CONFIGURATION:
                     _loc19_.amountSearchPattern = /%COUNT%/;
                     break;
                  case SimpleElement.TYPE_BOOTY_KEYS:
                     _loc19_.amountSearchPattern = /%AMOUNT%/;
               }
               if(_loc11_.@textColor.length() > 0)
               {
                  _loc19_.setColor(parseInt("0x" + String(_loc11_.@textColor)));
               }
               _loc7_.addElement(_loc19_,_loc9_,1);
               if(_loc12_ == SimpleElement.TYPE_BOOTY_KEYS)
               {
                  _loc7_.updateInfoField(SimpleElement.TYPE_BOOTY_KEYS);
               }
            }
            param1.addContainer(_loc7_);
            _loc7_.setPredefinedPosition();
         }
         return _loc5_;
      }
   }
}

