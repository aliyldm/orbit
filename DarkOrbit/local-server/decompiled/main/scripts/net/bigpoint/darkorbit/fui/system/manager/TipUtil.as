package net.bigpoint.darkorbit.fui.system.manager
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.repository.XMLUITemplateRepository;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.layout.LayoutAutoSizeMode;
   import net.bigpoint.darkorbit.fui.components.tooltip.ITooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.system.manager.mouse.MouseCursorDefinition;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class TipUtil
   {
      
      public function TipUtil()
      {
         super();
      }
      
      public static function showTip(param1:Sprite, param2:Container, param3:ITooltipDataAssigner, param4:Object) : void
      {
         TipUtil.assignTooltipData(param2,param3,param4);
         TipUtil.removeCurrentTooltipContainer(param2);
         TipUtil.updatePosition(param1,param2);
         TipUtil.addToTooltip(param2);
      }
      
      public static function addToTooltip(param1:Container) : void
      {
         UISystem.getInstance().tooltipManager.tooltipLayer.addChild(param1);
      }
      
      public static function createTip(param1:String) : Container
      {
         var _loc2_:Container = new Container();
         _loc2_.name = param1;
         _loc2_.autoSizeWidth = true;
         _loc2_.autoSizeHeight = true;
         _loc2_.clearAutoSizeMode();
         _loc2_.autoSizeMode = LayoutAutoSizeMode.CHILDREN_WIDTH | LayoutAutoSizeMode.CHILDREN_HEIGHT;
         var _loc3_:Object = XMLUITemplateRepository.getInstance().getTemplateByName(Coreponent.DEFAULT_TOOLTIP_TEMPLATE);
         UISystem.getInstance().build(_loc3_,_loc2_);
         return _loc2_;
      }
      
      public static function assignTooltipData(param1:Container, param2:ITooltipDataAssigner, param3:Object) : void
      {
         if(param2)
         {
            param2.target = param1;
            param2.data = param3;
            param2.assign();
            param1.forceRedraw(uint.MAX_VALUE,true);
         }
      }
      
      public static function removeCurrentTooltipContainer(param1:Container) : void
      {
         MovieClipUtils.removeDisplayObject(param1);
      }
      
      public static function updatePosition(param1:Sprite, param2:Container, param3:int = 16, param4:Number = 32) : void
      {
         var _loc7_:Rectangle = null;
         var _loc8_:MouseCursorDefinition = null;
         var _loc9_:Rectangle = null;
         var _loc10_:Rectangle = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc5_:DisplayObjectContainer = UISystem.getInstance().tooltipManager.tooltipLayer;
         var _loc6_:Stage = _loc5_.stage ? _loc5_.stage : null;
         if(param2)
         {
            _loc7_ = param1.getBounds(param1.stage);
            _loc8_ = UISystem.getInstance().mouseManager.cursorDefinition;
            _loc9_ = _loc8_.rightSideBounds;
            _loc10_ = _loc8_.leftSideBounds;
            _loc11_ = _loc6_.mouseX;
            _loc12_ = _loc6_.mouseY;
            if(_loc11_ < _loc7_.topLeft.x || _loc11_ > _loc7_.bottomRight.x)
            {
               param2.visible = false;
               return;
            }
            if(_loc12_ < _loc7_.topLeft.y || _loc12_ > _loc7_.bottomRight.y)
            {
               param2.visible = false;
               return;
            }
            param2.visible = true;
            _loc13_ = param2.getCalculatedWidth();
            _loc14_ = _loc6_.mouseX + param3;
            _loc15_ = _loc6_.stageWidth;
            if(_loc14_ + _loc13_ >= _loc15_)
            {
               _loc14_ -= _loc13_ + _loc10_.width;
            }
            else
            {
               _loc14_ += _loc9_.width;
            }
            _loc16_ = param2.getCalculatedHeight();
            _loc17_ = _loc6_.mouseY;
            _loc18_ = _loc6_.stageHeight;
            if(_loc17_ > _loc16_)
            {
               _loc17_ -= _loc16_;
            }
            if(_loc16_ + _loc17_ > _loc18_)
            {
               param2.x = _loc14_;
               if(_loc16_ > _loc18_)
               {
                  param2.y = 0;
               }
               else
               {
                  param2.y = _loc17_ - (_loc16_ + _loc17_ - _loc18_) - param4;
               }
            }
            else
            {
               param2.x = _loc14_;
               param2.y = _loc17_;
            }
            param2.forceRedraw(InvalidationType.POSITION);
         }
      }
   }
}

