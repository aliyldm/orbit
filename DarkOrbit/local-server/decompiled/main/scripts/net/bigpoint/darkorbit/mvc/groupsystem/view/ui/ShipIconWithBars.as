package net.bigpoint.darkorbit.mvc.groupsystem.view.ui
{
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.common.model.assetProxy.MapAssetLoadVo;
   
   public class ShipIconWithBars extends ShipIcon
   {
      
      private static const OFFSET:int = 2;
      
      private static const NOT_SET:String = "not_set";
      
      private var _hpBar:MemberLiveBar;
      
      private var _nanohullBar:MemberLiveBar;
      
      private var _shieldBar:MemberLiveBar;
      
      private var _shieldTooltip:ToolTipHook;
      
      private var _hpTooltip:ToolTipHook;
      
      private var _nanohullTooltip:ToolTipHook;
      
      private var _baseGraphic:Bitmap;
      
      private var _gameFacade:GameFacade = GameFacade.getInstance();
      
      public function ShipIconWithBars()
      {
         this.init();
         super();
      }
      
      override protected function createShutterGraphic() : void
      {
         super.createShutterGraphic();
      }
      
      private function init() : void
      {
         this._hpBar = new MemberLiveBar();
         this._nanohullBar = new MemberLiveBar();
         this._shieldBar = new MemberLiveBar();
         this._gameFacade.forwardNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(this.initBars,"ui",new <String>["empty_bar.png"],Bitmap));
      }
      
      private function initBars(param1:Bitmap) : void
      {
         this._baseGraphic = param1;
         this._gameFacade.forwardNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(this.handleHPbarInit,"ui",new <String>["hp_bar.png"],Bitmap));
      }
      
      private function handleNanoBarInit(param1:Bitmap) : void
      {
         this._nanohullBar.base = new Bitmap(this._baseGraphic.bitmapData);
         this._nanohullBar.lightClip = param1;
         this._nanohullBar.x = this._shieldBar.x;
         this._nanohullBar.y = this._shieldBar.y + this._shieldBar.height + OFFSET;
         this._nanohullTooltip = TooltipControl.getInstance().addToolTip(this._nanohullBar,NOT_SET + "nano");
         addChild(this._nanohullBar);
      }
      
      private function handleShieldBarInit(param1:Bitmap) : void
      {
         this._shieldBar.base = new Bitmap(this._baseGraphic.bitmapData);
         this._shieldBar.lightClip = param1;
         this._shieldBar.x = this._hpBar.x;
         this._shieldBar.y = this._hpBar.y + this._hpBar.height + OFFSET;
         this._shieldTooltip = TooltipControl.getInstance().addToolTip(this._shieldBar,NOT_SET + "shield");
         addChild(this._shieldBar);
         this._gameFacade.forwardNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(this.handleNanoBarInit,"ui",new <String>["nanohull_bar.png"],Bitmap));
      }
      
      private function handleHPbarInit(param1:Bitmap) : void
      {
         this._hpBar.base = new Bitmap(this._baseGraphic.bitmapData);
         this._hpBar.lightClip = param1;
         this._hpBar.x = 25;
         this._hpBar.y = 0;
         this._hpTooltip = TooltipControl.getInstance().addToolTip(this._hpBar,NOT_SET + "hp");
         addChild(this._hpBar);
         this._gameFacade.forwardNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(this.handleShieldBarInit,"ui",new <String>["shield_bar.png"],Bitmap));
      }
      
      public function get hpBar() : MemberLiveBar
      {
         return this._hpBar;
      }
      
      public function get nanohullBar() : MemberLiveBar
      {
         return this._nanohullBar;
      }
      
      public function get shieldBar() : MemberLiveBar
      {
         return this._shieldBar;
      }
      
      public function get shieldTooltip() : ToolTipHook
      {
         return this._shieldTooltip;
      }
      
      public function get hpTooltip() : ToolTipHook
      {
         return this._hpTooltip;
      }
      
      public function get nanohullTooltip() : ToolTipHook
      {
         return this._nanohullTooltip;
      }
   }
}

