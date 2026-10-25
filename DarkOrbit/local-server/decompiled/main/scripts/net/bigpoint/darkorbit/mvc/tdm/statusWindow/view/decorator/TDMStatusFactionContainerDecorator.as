package net.bigpoint.darkorbit.mvc.tdm.statusWindow.view.decorator
{
   import flash.display.Bitmap;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.components.BarComponent;
   import net.bigpoint.darkorbit.gui.windows.components.BarConfigVO;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.TDMStatusWindowConstants;
   
   public class TDMStatusFactionContainerDecorator
   {
      
      private var _barComp:BarComponent;
      
      private var barVo:BarConfigVO;
      
      public function TDMStatusFactionContainerDecorator(param1:SimpleContainer)
      {
         super();
         this.barVo = new BarConfigVO();
         this.barVo.solidBackground = false;
         this.barVo.totalbarWidth = TDMStatusWindowConstants.BAR_WIDTH;
         this.barVo.textlayout = BarConfigVO.TEXTLAYOUT_VALUE_OF_TOTLA;
         this._barComp = new BarComponent(0,null,this.barVo);
         this._barComp.setBarValueOnTop();
         this._barComp.removeBarClickability();
         this.decorate(param1);
      }
      
      private function decorate(param1:SimpleContainer) : void
      {
         param1.addElement(this._barComp);
      }
      
      public function updateFaction(param1:int) : void
      {
         this.barVo.barColor = InGameCatalog.instance.factions_colours[param1];
         this.updateFactionBitmap(param1);
      }
      
      public function updateFactionBitmap(param1:int) : void
      {
         var _loc2_:Bitmap = ResourceManager.getBitmap("icons","fraction" + param1);
         this._barComp.updateIcon(_loc2_);
      }
      
      public function get barComp() : BarComponent
      {
         return this._barComp;
      }
   }
}

