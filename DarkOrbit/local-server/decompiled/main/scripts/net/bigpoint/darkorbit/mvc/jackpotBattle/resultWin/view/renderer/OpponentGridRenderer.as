package net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.view.renderer
{
   import mx.core.IFlexModuleFactory;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.resultWin.model.vo.JackpotArenaMatchResultVO;
   
   public class OpponentGridRenderer extends JackpotItemBaseRenderer
   {
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function OpponentGridRenderer()
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
         var _loc2_:JackpotArenaMatchResultVO = param1 as JackpotArenaMatchResultVO;
         setToolTip(_loc2_.toolTipOpponent);
         super.data = _loc2_.opponent;
      }
   }
}

