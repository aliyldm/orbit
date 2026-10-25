package net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.renderer
{
   import flashx.textLayout.formats.TextAlign;
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.model.vo.JackpotArenaMatchResultVO;
   
   public class StatisticsRenderer extends JackpotItemBaseRenderer
   {
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function StatisticsRenderer()
      {
         super();
         mx_internal::_document = this;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override public function set data(param1:Object) : void
      {
         rowLabel.setStyle("textAlign",TextAlign.LEFT);
         rowLabel.setStyle("fontSize",11);
         var _loc2_:JackpotArenaMatchResultVO = param1 as JackpotArenaMatchResultVO;
         setToolTip(_loc2_.toolTipStats);
         super.data = _loc2_.stat;
      }
   }
}

