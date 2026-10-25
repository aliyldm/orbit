package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.TabSpaceSearchAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.TabSpaceSearchMissionsView;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.TabSpaceSearchRewardsView;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SpaceSearchRedDotData
   {
      
      private static var _instance:SpaceSearchRedDotData;
      
      public static var tabDictionary:Dictionary = new Dictionary();
      
      private var _highLight:Boolean;
      
      private var _missionHighLight:Boolean;
      
      private var _rewardHighLight:Boolean;
      
      private var _count:int;
      
      public const changed:ISignal = new Signal();
      
      public function SpaceSearchRedDotData()
      {
         super();
         _instance = this;
      }
      
      public static function get instance() : SpaceSearchRedDotData
      {
         return _instance;
      }
      
      public static function drawDot(param1:Sprite) : void
      {
         var _loc2_:Graphics = param1.graphics;
         _loc2_.clear();
         _loc2_.lineStyle(1,16777215);
         _loc2_.beginFill(16711680);
         _loc2_.drawCircle(0,0,4);
         _loc2_.endFill();
      }
      
      public function update(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         this._highLight = param1;
         this._missionHighLight = param2;
         this._rewardHighLight = param3;
         ++this._count;
         this.tryUpdate();
         this.changed.dispatch();
      }
      
      public function tryUpdate() : void
      {
         var _loc1_:TabSpaceSearchAssigner = null;
         if(SpaceSearchRedDotData.tabDictionary[TabSpaceSearchRewardsView.KEY])
         {
            _loc1_ = SpaceSearchRedDotData.tabDictionary[TabSpaceSearchRewardsView.KEY] as TabSpaceSearchAssigner;
            if(_loc1_)
            {
               _loc1_.redDotSprite.visible = this.rewardHighLight;
            }
         }
         if(SpaceSearchRedDotData.tabDictionary[TabSpaceSearchMissionsView.KEY])
         {
            _loc1_ = SpaceSearchRedDotData.tabDictionary[TabSpaceSearchMissionsView.KEY] as TabSpaceSearchAssigner;
            if(_loc1_)
            {
               _loc1_.redDotSprite.visible = false;
            }
         }
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function get highLight() : Boolean
      {
         return this._highLight;
      }
      
      public function get missionHighLight() : Boolean
      {
         return this._missionHighLight;
      }
      
      public function get rewardHighLight() : Boolean
      {
         return this._rewardHighLight;
      }
   }
}

