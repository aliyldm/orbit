package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.tab
{
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.items.TrinityTrialsDropInfoListItemRenderer;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy;
   
   public class TrinityTrialsDropInfoViewMediator extends SimpleWindowMediator
   {
      
      private var _proxy:TrinityTrialsMainProxy;
      
      private var _view:TrinityTrialsDropInfoView;
      
      private var dataComplet:Boolean = false;
      
      public function TrinityTrialsDropInfoViewMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         this._proxy = TrinityTrialsMainProxy.getProxy();
         this._proxy.viewData.dataChange.add(this.update);
      }
      
      public function setView(param1:TrinityTrialsDropInfoView) : void
      {
         this._view = param1;
         this._view.item_list.itemDataAssigner = TrinityTrialsDropInfoListItemRenderer;
         if(this.dataComplet)
         {
            this.dataComplet = false;
            this.setViewData();
         }
      }
      
      public function update(param1:String) : void
      {
         if(param1 != TrinityTrialsConst.TAB_3)
         {
            return;
         }
         this.dataComplet = true;
         if(this._view)
         {
            this.setViewData();
         }
      }
      
      private function setViewData() : void
      {
         this._view.item_list.list = new VectorCollection(this._proxy.viewData.dropInfoData.rewardDescriptionList);
      }
   }
}

