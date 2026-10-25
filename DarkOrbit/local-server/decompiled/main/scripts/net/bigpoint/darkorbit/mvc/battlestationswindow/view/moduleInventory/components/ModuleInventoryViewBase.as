package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.components
{
   import com.greensock.TweenLite;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import mx.core.DragSource;
   import mx.events.DragEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.DragManager;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.BattleStationConstants;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.model.ModuleVO;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.ModuleItem;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.events.BattleStationWindowEvent;
   import spark.components.Image;
   import spark.components.Label;
   import spark.components.List;
   import spark.components.SkinnableContainer;
   
   public class ModuleInventoryViewBase extends SkinnableContainer
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _2083175645moduleItemList:List;
      
      private var _1791483012titleLabel:Label;
      
      private var currentSelectedModuleItem:ModuleItem;
      
      protected var _viewCreated:Boolean;
      
      protected var _moduleItemList:ArrayCollection;
      
      public function ModuleInventoryViewBase()
      {
         super();
      }
      
      protected function creationCompleteHandler() : void
      {
         this.titleLabel.text = BPLocale.getItem("label_bswin_mod_inventory");
      }
      
      protected function handleItemClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = this.moduleItemList.selectedIndex;
         if(this.currentSelectedModuleItem != null)
         {
            this.currentSelectedModuleItem.selected = false;
         }
         this.currentSelectedModuleItem = ModuleItem(Object(this.moduleItemList.dataGroup.getElementAt(_loc2_)).moduleItemComponent);
         this.currentSelectedModuleItem.selected = true;
      }
      
      protected function handleStartDrag(param1:DragEvent) : void
      {
         var _loc4_:ModuleVO = null;
         var _loc5_:DragSource = null;
         var _loc6_:String = null;
         var _loc7_:MovieClip = null;
         var _loc8_:Image = null;
         var _loc2_:int = this.moduleItemList.selectedIndex;
         var _loc3_:ModuleItem = ModuleItem(Object(this.moduleItemList.dataGroup.getElementAt(_loc2_)).moduleItemComponent);
         if(_loc3_)
         {
            if(this.currentSelectedModuleItem != null)
            {
               this.currentSelectedModuleItem.selected = false;
            }
            this.currentSelectedModuleItem = _loc3_;
            this.currentSelectedModuleItem.selected = true;
            _loc4_ = ModuleVO(ModuleItem(Object(this.moduleItemList.dataGroup.getElementAt(_loc2_)).moduleItemComponent).moduleVO);
            _loc5_ = new DragSource();
            _loc5_.addData(_loc4_,"moduleData");
            _loc6_ = BattleStationConstants.moduleResKeyLookup[_loc4_.type];
            _loc7_ = ResourceManager.getMovieClip("battleStationsUI",_loc6_);
            _loc8_ = new Image();
            _loc8_.source = _loc7_;
            DragManager.doDrag(_loc3_,_loc5_,param1,_loc8_,1,1,1);
         }
      }
      
      public function setPlayerModules(param1:ArrayCollection) : void
      {
         callLater(this.setPlayerModulesCalledLater,[param1]);
      }
      
      private function setPlayerModulesCalledLater(param1:ArrayCollection) : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ModuleVO = null;
         var _loc2_:ArrayCollection = new ArrayCollection(param1.toArray());
         if(_loc2_.length < 18)
         {
            _loc3_ = 18 - _loc2_.length;
         }
         else if(_loc2_.length > 18)
         {
            _loc5_ = _loc2_.length % 6;
            if(_loc5_ != 0)
            {
               _loc3_ = 6 - _loc5_;
            }
         }
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc6_ = new ModuleVO();
            _loc6_.type = ModuleVO.NONE;
            _loc6_.draggable = false;
            _loc2_.addItem(_loc6_);
            _loc4_++;
         }
         this._moduleItemList = new ArrayCollection(_loc2_.source);
         if(this._viewCreated)
         {
            this.moduleItemList.dataProvider = this._moduleItemList;
         }
         if(this.currentSelectedModuleItem != null)
         {
            this.currentSelectedModuleItem.selected = false;
         }
      }
      
      protected function showInventoryPopupHandler(param1:Event) : void
      {
         dispatchEvent(new BattleStationWindowEvent(BattleStationWindowEvent.SHOW_INVENTORY_FILTER_POPUP,true));
      }
      
      public function set viewCreated(param1:Boolean) : void
      {
         this._viewCreated = param1;
         if(this._moduleItemList)
         {
            TweenLite.delayedCall(0.15,this.setDataProvider);
         }
      }
      
      private function setDataProvider() : void
      {
         callLater(this.setDataProviderCalledLater);
      }
      
      private function setDataProviderCalledLater() : void
      {
         this.moduleItemList.dataProvider = this._moduleItemList;
      }
      
      [Bindable(event="propertyChange")]
      public function get moduleItemList() : List
      {
         return this._2083175645moduleItemList;
      }
      
      public function set moduleItemList(param1:List) : void
      {
         var _loc2_:Object = this._2083175645moduleItemList;
         if(_loc2_ !== param1)
         {
            this._2083175645moduleItemList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"moduleItemList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get titleLabel() : Label
      {
         return this._1791483012titleLabel;
      }
      
      public function set titleLabel(param1:Label) : void
      {
         var _loc2_:Object = this._1791483012titleLabel;
         if(_loc2_ !== param1)
         {
            this._1791483012titleLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleLabel",_loc2_,param1));
            }
         }
      }
   }
}

