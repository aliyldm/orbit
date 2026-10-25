package net.bigpoint.darkorbit.fui.system.manager
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.builder.repository.XMLUITemplateRepository;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.layout.LayoutAutoSizeMode;
   import net.bigpoint.darkorbit.fui.components.tooltip.ITooltipDataAssigner;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class TooltipManager implements ITooltipManager
   {
      
      protected static const TOOLTIP_CONTAINER_NAME:String = "tooltipContainer";
      
      private var _tooltipLayer:DisplayObjectContainer;
      
      private var _currentTooltipContainer:Container;
      
      private var _currentTooltipTarget:Coreponent;
      
      private var _currentTemplateID:String;
      
      private var _showTooltipIntervalID:uint;
      
      private var _showTooltipDelay:uint = 1000;
      
      private var _enable:Boolean = true;
      
      private const MOUSE_CURSOR_WIDTH:int = 16;
      
      private const BOTTOM_OFFSET:Number = 32;
      
      private var _thisFrameDisabled:Boolean;
      
      public function TooltipManager(param1:DisplayObjectContainer)
      {
         super();
         this.tooltipLayer = param1;
         this.init();
      }
      
      public function get tooltipLayer() : DisplayObjectContainer
      {
         return this._tooltipLayer;
      }
      
      public function set tooltipLayer(param1:DisplayObjectContainer) : void
      {
         this._tooltipLayer = param1;
         this._tooltipLayer.mouseChildren = false;
         this._tooltipLayer.mouseEnabled = false;
      }
      
      public function get showTooltipDelay() : uint
      {
         return this._showTooltipDelay;
      }
      
      public function set showTooltipDelay(param1:uint) : void
      {
         this._showTooltipDelay = param1;
      }
      
      protected function get stage() : Stage
      {
         return this._tooltipLayer.stage ? this._tooltipLayer.stage : null;
      }
      
      public function attemptToRemoveTooltip() : void
      {
         this.clearShowTooltipTimeout();
         this.removeCurrentTooltipContainer();
      }
      
      public function assignTooltipTemplateID(param1:String, param2:Coreponent = null, param3:int = 1000) : void
      {
         if(!this.isEnabled() || this._thisFrameDisabled)
         {
            return;
         }
         this._currentTooltipTarget = param2;
         this._currentTemplateID = param1;
         this.removeCurrentTooltipContainer();
         this.clearShowTooltipTimeout();
         if(this._currentTooltipTarget.tooltipData)
         {
            this._thisFrameDisabled = true;
            setTimeout(this.enableFrame,1);
            this._showTooltipIntervalID = setTimeout(this.showTooltip,param3);
         }
      }
      
      private function enableFrame() : void
      {
         this._thisFrameDisabled = false;
      }
      
      public function disable() : void
      {
         this._enable = false;
         this.clearShowTooltipTimeout();
         this.removeCurrentTooltipContainer();
      }
      
      public function enable() : void
      {
         this._enable = true;
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         if(param1)
         {
            this.enable();
         }
         else
         {
            this.disable();
         }
      }
      
      public function isEnabled() : Boolean
      {
         return this._enable;
      }
      
      protected function init() : void
      {
         if(this.stage)
         {
            this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEvent);
         }
      }
      
      protected function clearShowTooltipTimeout() : void
      {
         clearTimeout(this._showTooltipIntervalID);
      }
      
      protected function showTooltip() : void
      {
         if(this._currentTooltipTarget.tooltipData == null || this._currentTooltipTarget.stage == null)
         {
            return;
         }
         if(this._currentTooltipContainer)
         {
            this._currentTooltipContainer.removeChildren();
            MovieClipUtils.removeDisplayObject(this._currentTooltipContainer);
         }
         this._currentTooltipContainer = new Container();
         this._currentTooltipContainer.name = TOOLTIP_CONTAINER_NAME;
         this._currentTooltipContainer.autoSizeWidth = true;
         this._currentTooltipContainer.autoSizeHeight = true;
         this._currentTooltipContainer.clearAutoSizeMode();
         this._currentTooltipContainer.autoSizeMode = LayoutAutoSizeMode.CHILDREN_WIDTH | LayoutAutoSizeMode.CHILDREN_HEIGHT;
         var _loc1_:Object = XMLUITemplateRepository.getInstance().getTemplateByName(this._currentTooltipTarget.tooltipTemplateID);
         UISystem.getInstance().build(_loc1_,this._currentTooltipContainer);
         this.assignTooltipData();
         this.updatePosition();
         this.removeCurrentTooltipContainer();
         this.addTooltipContainer();
      }
      
      protected function assignTooltipData() : void
      {
         var _loc1_:ITooltipDataAssigner = this._currentTooltipTarget.tooltipDataAssigner;
         if(_loc1_)
         {
            _loc1_.target = this._currentTooltipContainer;
            _loc1_.data = this._currentTooltipTarget.tooltipData;
            _loc1_.assign();
            this._currentTooltipContainer.forceRedraw(uint.MAX_VALUE,true);
         }
      }
      
      protected function updatePosition() : void
      {
         if(!this._currentTooltipTarget || !this._currentTooltipTarget.stage)
         {
            this.attemptToRemoveTooltip();
            return;
         }
         if(this._currentTooltipContainer)
         {
            TipUtil.updatePosition(this._currentTooltipTarget,this._currentTooltipContainer,this.MOUSE_CURSOR_WIDTH,this.BOTTOM_OFFSET);
         }
      }
      
      protected function updateSize() : void
      {
      }
      
      protected function removeCurrentTooltipContainer() : void
      {
         MovieClipUtils.removeDisplayObject(this._currentTooltipContainer);
      }
      
      protected function addTooltipContainer() : void
      {
         if(this._currentTooltipContainer)
         {
            if(!this._currentTooltipContainer.stage)
            {
               this._tooltipLayer.addChild(this._currentTooltipContainer);
            }
         }
      }
      
      protected function handleMouseMoveEvent(param1:MouseEvent) : void
      {
         this.updatePosition();
      }
      
      public function hasToolTip(param1:Coreponent) : Boolean
      {
         return this._currentTooltipTarget == param1;
      }
   }
}

