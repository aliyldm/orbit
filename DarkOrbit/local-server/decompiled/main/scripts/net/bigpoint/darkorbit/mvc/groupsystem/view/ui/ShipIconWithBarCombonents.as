package net.bigpoint.darkorbit.mvc.groupsystem.view.ui
{
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import net.bigpoint.darkorbit.gui.windows.components.BarComponent;
   import net.bigpoint.darkorbit.gui.windows.components.BarConfigVO;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.common.model.assetProxy.MapAssetLoadVo;
   
   public class ShipIconWithBarCombonents extends ShipIcon
   {
      
      private static const OFFSET:int = 7;
      
      private static const BAR_HEIGHT:int = 4;
      
      private static const NOT_SET:String = "not_set";
      
      private const BAR_WIDTH:int = 60;
      
      private const SHIELD_COLOR:int = 255;
      
      private const HP_COLOR:int = 65280;
      
      private const NANO_COLOR:int = 16776960;
      
      private var _barVo:BarConfigVO;
      
      private var _hpBar:BarComponent;
      
      private var _nanohullBar:BarComponent;
      
      private var _shieldBar:BarComponent;
      
      private var _shieldTooltip:ToolTipHook;
      
      private var _hpTooltip:ToolTipHook;
      
      private var _nanohullTooltip:ToolTipHook;
      
      private var _baseGraphic:Bitmap;
      
      private var _gameFacade:GameFacade = GameFacade.getInstance();
      
      public function ShipIconWithBarCombonents()
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
         this._hpBar = new BarComponent(this.HP_COLOR,null,this.getBarVo(this.HP_COLOR));
         this._hpBar.mouseChildren = false;
         this._nanohullBar = new BarComponent(this.NANO_COLOR,null,this.getBarVo(this.NANO_COLOR));
         this._nanohullBar.mouseChildren = false;
         this._shieldBar = new BarComponent(this.SHIELD_COLOR,null,this.getBarVo(this.SHIELD_COLOR));
         this._shieldBar.mouseChildren = false;
         this._gameFacade.forwardNotification(MapAssetNotification.LOAD_GRAPHICS_FOR_MAPASSET,new MapAssetLoadVo(this.initBars,"ui",new <String>["empty_bar.png"],Bitmap,null,false));
      }
      
      private function initBars(param1:Bitmap) : void
      {
         this._baseGraphic = param1;
         this.initHPbarInit();
         this.intShieldBarInit();
         this.initNanoBarInit();
      }
      
      private function initNanoBarInit() : void
      {
         this._nanohullBar.x = this._shieldBar.x;
         this._nanohullBar.y = this._shieldBar.y + OFFSET;
         this._nanohullTooltip = TooltipControl.getInstance().addToolTip(this._nanohullBar,NOT_SET + "nano");
         addChild(this._nanohullBar);
      }
      
      private function intShieldBarInit() : void
      {
         this._shieldBar.x = this._hpBar.x;
         this._shieldBar.y = this._hpBar.y + OFFSET;
         this._shieldTooltip = TooltipControl.getInstance().addToolTip(this._shieldBar,NOT_SET + "shield");
         addChild(this._shieldBar);
      }
      
      private function initHPbarInit() : void
      {
         this._hpBar.x = 25;
         this._hpBar.y = -2;
         this._hpTooltip = TooltipControl.getInstance().addToolTip(this._hpBar,NOT_SET + "hp");
         addChild(this._hpBar);
      }
      
      public function get hpBar() : BarComponent
      {
         return this._hpBar;
      }
      
      public function get nanohullBar() : BarComponent
      {
         return this._nanohullBar;
      }
      
      public function get shieldBar() : BarComponent
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
      
      public function getBarVo(param1:uint) : BarConfigVO
      {
         if(!this._barVo)
         {
            this._barVo = new BarConfigVO();
         }
         this._barVo.gap = 1;
         this._barVo.totalbarWidth = this.BAR_WIDTH;
         this._barVo.totalbarHeight = BAR_HEIGHT;
         this._barVo.backgroundColor = 1842204;
         this._barVo.barColor = param1;
         this._barVo.solidBackground = false;
         return this._barVo.clone();
      }
   }
}

