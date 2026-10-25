package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.tooltip
{
   import com.bealearts.collection.VectorCollection;
   import flash.events.Event;
   import mx.binding.BindingManager;
   import mx.core.IFlexModuleFactory;
   import mx.core.IToolTip;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMRewardsModel;
   import spark.components.Group;
   
   public class TDMResultWindowToolTipContainer extends Group implements IToolTip
   {
      
      private var _1690836757rewardGrid:TDMResultWindowToolTip;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _rewards:TDMRewardsModel;
      
      public function TDMResultWindowToolTipContainer()
      {
         super();
         mx_internal::_document = this;
         this.width = 320;
         this.mxmlContent = [this._TDMResultWindowToolTipContainer_TDMResultWindowToolTip1_i()];
         this.addEventListener("creationComplete",this.___TDMResultWindowToolTipContainer_Group1_creationComplete);
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
      
      public function set rewards(param1:TDMRewardsModel) : void
      {
         this._rewards = param1;
         this.rewardGrid.dataProvider = new VectorCollection(this._rewards.rewardList);
      }
      
      public function set dataProvider(param1:VectorCollection) : void
      {
         this.rewardGrid.dataProvider = param1;
      }
      
      public function get text() : String
      {
         return "";
      }
      
      public function set text(param1:String) : void
      {
      }
      
      protected function handleCreationComplete(param1:Event) : void
      {
         this.rewardGrid.setTitle(this._rewards.title);
         this.rewardGrid.setMessage(this._rewards.message);
      }
      
      private function _TDMResultWindowToolTipContainer_TDMResultWindowToolTip1_i() : TDMResultWindowToolTip
      {
         var _loc1_:TDMResultWindowToolTip = new TDMResultWindowToolTip();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.id = "rewardGrid";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.rewardGrid = _loc1_;
         BindingManager.executeBindings(this,"rewardGrid",this.rewardGrid);
         return _loc1_;
      }
      
      public function ___TDMResultWindowToolTipContainer_Group1_creationComplete(param1:FlexEvent) : void
      {
         this.handleCreationComplete(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get rewardGrid() : TDMResultWindowToolTip
      {
         return this._1690836757rewardGrid;
      }
      
      public function set rewardGrid(param1:TDMResultWindowToolTip) : void
      {
         var _loc2_:Object = this._1690836757rewardGrid;
         if(_loc2_ !== param1)
         {
            this._1690836757rewardGrid = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rewardGrid",_loc2_,param1));
            }
         }
      }
   }
}

