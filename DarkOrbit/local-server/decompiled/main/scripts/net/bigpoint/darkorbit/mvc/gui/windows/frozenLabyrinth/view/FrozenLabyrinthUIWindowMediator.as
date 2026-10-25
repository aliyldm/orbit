package net.bigpoint.darkorbit.mvc.gui.windows.frozenLabyrinth.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.mvc.gui.windows.ItemLoader;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.frozenLabyrinth.model.FrozenLabyrinthUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.frozenLabyrinth.view.components.FrozenLabyrinthRootView;
   
   public class FrozenLabyrinthUIWindowMediator extends SimpleWindowMediator
   {
      
      private var _data:FrozenLabyrinthUIData;
      
      private var _view:FrozenLabyrinthRootView;
      
      public function FrozenLabyrinthUIWindowMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         param2.setSize(450,270);
      }
      
      public function set data(param1:FrozenLabyrinthUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.timer.changed.remove(this.updateTimer);
            this._data.labyrinthKeys.changed.remove(this.updateKeys);
            this._data.synkChanged.remove(this.updateSynkLocationText);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.timer.changed.add(this.updateTimer);
            this._data.labyrinthKeys.changed.add(this.updateKeys);
            this._data.synkChanged.add(this.updateSynkLocationText);
            this.update();
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new FrozenLabyrinthRootView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as FrozenLabyrinthUIData;
         this.loadLabyrinthKeyImage();
      }
      
      private function loadLabyrinthKeyImage() : void
      {
         var _loc4_:ItemLoader = null;
         var _loc1_:String = "";
         var _loc2_:String = "resource_key_access-flb";
         var _loc3_:Coreponent = this._view.overView.keyDisplay;
         _loc4_ = new ItemLoader(_loc2_);
         var _loc5_:ItemVO = ItemDataProviderHelper.getItem(_loc2_);
         if(_loc5_.fullname)
         {
            _loc1_ += _loc5_.fullname + "\n";
         }
         if(_loc5_.rawDescription)
         {
            _loc1_ += _loc5_.descriptionName + "\n";
         }
         TooltipControl.getInstance().addToolTip(_loc4_,_loc1_);
         _loc3_.addChild(_loc4_);
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this._view.synkView.list.list = new VectorCollection(this._data.topRankers);
            this.updateOwnRank();
            this.updateTopDescription();
            this.updateTimer();
            this.updateKeys();
            this.updateSynkLocationText();
         }
      }
      
      private function updateTopDescription() : void
      {
         if(Boolean(this._data) && Boolean(this._view) && Boolean(this._data.topDescription))
         {
            this._view.overView.topDescription.localizedText = this._data.topDescription;
         }
      }
      
      private function updateTimer() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.timer.value > 0)
            {
               this._view.overView.timer.text = TimeFormatter.getSmartFormatedTime(this._data.timer.value);
            }
            else
            {
               this._view.overView.timer.text = "";
            }
            this.updateSynkLocationText();
         }
      }
      
      private function updateKeys() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.overView.keyAmount.text = TextFormatter.roundInteger(this._data.labyrinthKeys.value);
         }
      }
      
      private function updateSynkLocationText() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(Boolean(this._data) && Boolean(this._view))
         {
            _loc1_ = this._data._synkLocation;
            if(_loc1_.respawnInSeconds.value > 0)
            {
               this._view.overView.synkLocationTextLeft.text = BPLocale.getItem("frozen_labyrinth_synk_status_dead");
               this._view.overView.synkLocationTextRight.text = TimeFormatter.getSmartFormatedTime(_loc1_.respawnInSeconds.value);
            }
            else if(Boolean(_loc1_.isGateActive) && Boolean(_loc1_.mapName) && _loc1_.zone > 0)
            {
               this._view.overView.synkLocationTextLeft.text = BPLocale.getItem("frozen_labyrinth_synk_status_spawned");
               _loc2_ = BPLocale.getItem("frozen_labyrinth_synk_status_location");
               _loc2_ = _loc2_.replace("%MAP%",_loc1_.mapName);
               _loc2_ = _loc2_.replace("%ZONE%",_loc1_.zone.toString());
               this._view.overView.synkLocationTextRight.text = _loc2_;
            }
            else
            {
               this._view.overView.synkLocationTextLeft.text = "";
               this._view.overView.synkLocationTextRight.text = "";
            }
         }
      }
      
      private function updateOwnRank() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.ownRank.rank == 0)
            {
               this._view.synkView.ownRank.text = "-";
               this._view.synkView.ownName.text = this._data.ownRank.name;
               this._view.synkView.ownTime.text = "-";
               this._view.synkView.ownKills.text = "-";
            }
            else
            {
               this._view.synkView.ownRank.text = TextFormatter.roundInteger(this._data.ownRank.rank);
               this._view.synkView.ownName.text = this._data.ownRank.name;
               this._view.synkView.ownTime.text = this._data.ownRank.lastKillTime;
               this._view.synkView.ownKills.text = TextFormatter.roundInteger(this._data.ownRank.kills);
            }
         }
      }
   }
}

