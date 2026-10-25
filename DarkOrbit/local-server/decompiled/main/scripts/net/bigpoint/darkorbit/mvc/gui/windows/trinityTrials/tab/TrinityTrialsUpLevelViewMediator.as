package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.tab
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsUIRequest;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.items.TrinityTrialsUpDropLevelItemRenderer;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.DropLevelVo;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.EventCenter;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.GameEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.GameEventConst;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   
   public class TrinityTrialsUpLevelViewMediator extends SimpleWindowMediator
   {
      
      private var _proxy:TrinityTrialsMainProxy;
      
      private var _view:TrinityTrialsUpLevelView;
      
      private var dataComplete:Boolean = false;
      
      public function TrinityTrialsUpLevelViewMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         this._proxy = TrinityTrialsMainProxy.getProxy();
         this._proxy.viewData.dataChange.add(this.update);
         EventCenter.instance.addEventListener(GameEventConst.UP_DROP_LEVEL_COMPLETE,this.upLevelComplete);
      }
      
      public function setView(param1:TrinityTrialsUpLevelView) : void
      {
         this._view = param1;
         this._view.current_level_info_list.itemDataAssigner = TrinityTrialsUpDropLevelItemRenderer;
         this._view.next_level_info_list.itemDataAssigner = TrinityTrialsUpDropLevelItemRenderer;
         this.setListData();
      }
      
      private function update(param1:String) : void
      {
         if(param1 != TrinityTrialsConst.TAB_2)
         {
            return;
         }
         this.dataComplete = true;
         if(this._view)
         {
            this.setListData();
         }
      }
      
      private function setListData() : void
      {
         var _loc1_:Vector.<DropLevelVo> = null;
         var _loc2_:Vector.<DropLevelVo> = null;
         var _loc3_:String = null;
         if(this.dataComplete)
         {
            this.dataComplete = false;
            this._view.current_level_label.text = BPLocale.getItemInCategory("","trinitytrials_upgrade_current_level").replace("%VALUE%",this._proxy.viewData.upLevelData.currentLevel);
            _loc1_ = this._proxy.viewData.getUpLevelItems("currentLevelQualityRandomList");
            this._view.current_level_info_list.list = new VectorCollection(_loc1_);
            _loc2_ = this._proxy.viewData.getUpLevelItems("nextLevelQualityRandomList");
            if(_loc2_.length > 0)
            {
               _loc3_ = BPLocale.getItemInCategory("","trinitytrials_upgrade_next_level").replace("%VALUE%","");
               _loc3_ += HtmlTextUtils.coloriseText(65280,TextFormatter.roundInteger(this._proxy.viewData.upLevelData.nextLevel));
               this._view.next_level_label.useHTML = true;
               this._view.next_level_label.text = _loc3_;
               this._view.next_level_info_list.list = new VectorCollection(_loc2_);
               this._view.listGroup.width = this._view.item_list_bg.width;
               if(this._proxy.viewData.upLevelData.buildSeconds <= 0)
               {
                  this._view.costItemGroup.update();
                  this._view.upLevelCostGroup.visible = true;
                  this._view.skipUpLevelCostGroup.visible = false;
               }
               else
               {
                  this._view.upLevelCostGroup.visible = false;
                  this._view.skipItemGroup.update();
                  this._view.skipUpLevelCostGroup.visible = true;
               }
            }
            else
            {
               this._view.item_list_bg.visible = false;
               this._view.item_list_bg_max.visible = true;
               this._view.next_level_info_list.width = 0;
               this._view.next_level_label.visible = false;
               this._view.up_arrow.visible = false;
               this._view.skipUpLevelCostGroup.visible = false;
               this._view.upLevelCostGroup.visible = false;
               this._view.skipItemGroup.stop();
               this._view.listGroup.width = this._view.item_list_bg_max.width;
            }
            this._view.listGroup.forceRedraw(InvalidationType.SIZE,true);
            this._view.listGroup.forceRedraw(InvalidationType.POSITION);
         }
      }
      
      private function upLevelComplete(param1:GameEvent) : void
      {
         this._proxy.sendUIRequest(TrinityTrialsUIRequest.OPTIONALTYPE_DROP_LEVEL);
         this._view.skipUpLevelCostGroup.visible = false;
         this._view.upLevelCostGroup.visible = true;
      }
   }
}

