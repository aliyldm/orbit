package net.bigpoint.darkorbit.mvc.companyhierarchy.view.components
{
   import mx.collections.ArrayCollection;
   import mx.collections.ArrayList;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOWindow;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.model.vo.RankedClanVO;
   import spark.components.Label;
   import spark.components.List;
   
   public class CompanyHierarchyWindowBase extends DOWindow
   {
      
      private static var _skinParts:Object = {
         "moveArea":false,
         "closeButton":false,
         "controlBarGroup":false,
         "contentGroup":false,
         "titleDisplay":false,
         "resizeHandle":false
      };
      
      private var _1553853997tabList:ArrayCollection = new ArrayCollection([{
         "label":"MMO",
         "factionID":1
      },{
         "label":"EIC",
         "factionID":2
      },{
         "label":"VRU",
         "factionID":3
      }]);
      
      private var _1106754295leader:RankedClanItem;
      
      private var _1683053791bottomClan:RankedClanItem;
      
      private var _956058097itsYourClan:Label;
      
      private var _1067526194rankedClanItemList:List;
      
      public function CompanyHierarchyWindowBase()
      {
         super();
      }
      
      public function updateClansList(param1:ArrayList) : void
      {
         if(param1 == null || param1.length == 0)
         {
            this.leader.visible = false;
            this.rankedClanItemList.dataProvider = new ArrayList();
            this.bottomClan.visible = false;
            this.itsYourClan.visible = false;
            return;
         }
         var _loc2_:ArrayList = new ArrayList(param1.toArray());
         if((_loc2_.getItemAt(_loc2_.length - 1) as RankedClanVO).clanId == Hero.clanID)
         {
            this.bottomClan.rankedClanVO = _loc2_.removeItemAt(_loc2_.length - 1) as RankedClanVO;
            this.bottomClan.visible = true;
         }
         else
         {
            this.bottomClan.visible = false;
         }
         this.itsYourClan.visible = this.bottomClan.visible;
         if(_loc2_.length >= 1)
         {
            this.leader.rankedClanVO = _loc2_.removeItemAt(0) as RankedClanVO;
            this.leader.visible = true;
         }
         this.rankedClanItemList.dataProvider = _loc2_;
      }
      
      public function onTabChange(param1:int) : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get tabList() : ArrayCollection
      {
         return this._1553853997tabList;
      }
      
      public function set tabList(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1553853997tabList;
         if(_loc2_ !== param1)
         {
            this._1553853997tabList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tabList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leader() : RankedClanItem
      {
         return this._1106754295leader;
      }
      
      public function set leader(param1:RankedClanItem) : void
      {
         var _loc2_:Object = this._1106754295leader;
         if(_loc2_ !== param1)
         {
            this._1106754295leader = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leader",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomClan() : RankedClanItem
      {
         return this._1683053791bottomClan;
      }
      
      public function set bottomClan(param1:RankedClanItem) : void
      {
         var _loc2_:Object = this._1683053791bottomClan;
         if(_loc2_ !== param1)
         {
            this._1683053791bottomClan = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomClan",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get itsYourClan() : Label
      {
         return this._956058097itsYourClan;
      }
      
      public function set itsYourClan(param1:Label) : void
      {
         var _loc2_:Object = this._956058097itsYourClan;
         if(_loc2_ !== param1)
         {
            this._956058097itsYourClan = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itsYourClan",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rankedClanItemList() : List
      {
         return this._1067526194rankedClanItemList;
      }
      
      public function set rankedClanItemList(param1:List) : void
      {
         var _loc2_:Object = this._1067526194rankedClanItemList;
         if(_loc2_ !== param1)
         {
            this._1067526194rankedClanItemList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rankedClanItemList",_loc2_,param1));
            }
         }
      }
   }
}

