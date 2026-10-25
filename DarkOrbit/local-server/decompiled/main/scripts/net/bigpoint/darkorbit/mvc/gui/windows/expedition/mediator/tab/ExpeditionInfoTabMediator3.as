package net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator.tab
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.ExpeditionInfoProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.ExpeditionInfoTabView3;
   
   public class ExpeditionInfoTabMediator3 extends SimpleWindowMediator
   {
      
      private var _view:ExpeditionInfoTabView3;
      
      private var _proxy:ExpeditionInfoProxy;
      
      public function ExpeditionInfoTabMediator3(param1:String, param2:IWindow)
      {
         super(param1,param2);
         this._proxy = ExpeditionInfoProxy.getProxy(GameFacade.getInstance());
         this._proxy.viewData.change.addOnce(this.update);
      }
      
      public function setView(param1:ExpeditionInfoTabView3) : void
      {
         this._view = param1;
         this.update();
      }
      
      public function update() : void
      {
         if(!this._view || !this._proxy.viewData.rewardRange)
         {
            return;
         }
         this._view.tab3List.setData(new VectorCollection(this._proxy.viewData.rewardRange));
         var _loc1_:String = BPLocale.getItemInCategory("","window_dse_reward_set_time").replace("%VALUE%",this._proxy.viewData.infoCommand.eventEndTime);
         var _loc2_:String = "";
         if(this._proxy.viewData.infoCommand.myRank > 0)
         {
            _loc2_ = BPLocale.getItemInCategory("","window_dse_reward_record").replace("%VALUE%",this._proxy.viewData.infoCommand.myRank);
            _loc2_ += "   ";
         }
         this._view.rest_time_label.text = _loc2_ + _loc1_;
      }
   }
}

