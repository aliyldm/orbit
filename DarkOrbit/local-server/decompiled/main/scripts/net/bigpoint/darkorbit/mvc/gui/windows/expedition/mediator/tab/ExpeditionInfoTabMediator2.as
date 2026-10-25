package net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator.tab
{
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.ExpeditionInfoProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.vo.BoxesVo;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.ExpeditionInfoTabView2;
   
   public class ExpeditionInfoTabMediator2 extends SimpleWindowMediator
   {
      
      private var _view:ExpeditionInfoTabView2;
      
      public function ExpeditionInfoTabMediator2(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      public function setView(param1:ExpeditionInfoTabView2) : void
      {
         this._view = param1;
      }
      
      public function update() : void
      {
         var _loc1_:Vector.<BoxesVo> = ExpeditionInfoProxy.getProxy(GameFacade.getInstance()).viewData.getBoxesReward();
         this._view.rewardList = _loc1_;
      }
   }
}

