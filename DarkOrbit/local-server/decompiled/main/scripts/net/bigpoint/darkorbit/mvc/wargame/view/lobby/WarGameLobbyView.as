package net.bigpoint.darkorbit.mvc.wargame.view.lobby
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class WarGameLobbyView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function WarGameLobbyView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1.getChildAt(0) as DisplayObjectContainer);
      }
      
      public function get infoLabel() : Label
      {
         return this._cache.selectComponent("lobby_container.info_container.wargame_desc_container.content") as Label;
      }
      
      public function get singUpButton() : Button
      {
         return this._cache.selectComponent("lobby_container.action_container.ready.btn") as Button;
      }
      
      public function get rewardsLeftButton() : Button
      {
         return this._cache.selectComponent("lobby_container.rewards_container.left") as Button;
      }
      
      public function get rewardsRightButton() : Button
      {
         return this._cache.selectComponent("lobby_container.rewards_container.right") as Button;
      }
      
      public function get rewards() : ItemList
      {
         return this._cache.selectComponent("lobby_container.rewards_container.rewards") as ItemList;
      }
      
      public function get root() : Coreponent
      {
         return this._cache.selectComponent("lobby_container") as Coreponent;
      }
      
      public function get stateREADYContainer() : Coreponent
      {
         return this._cache.selectComponent("lobby_container.action_container.ready") as Coreponent;
      }
      
      public function get stateGEAR_SCORE_TOO_LOWContainer() : Coreponent
      {
         return this._cache.selectComponent("lobby_container.action_container.too_low") as Coreponent;
      }
      
      public function get stateIN_QUEUEContainer() : Coreponent
      {
         return this._cache.selectComponent("lobby_container.action_container.signup_running") as Coreponent;
      }
      
      public function get stateIN_QUEUEContainerLeave() : Button
      {
         return this._cache.selectComponent("lobby_container.action_container.signup_running.btn") as Button;
      }
      
      public function get stateIN_QUEUEContainerTimeLeft() : Label
      {
         return this._cache.selectComponent("lobby_container.action_container.signup_running.timer") as Label;
      }
   }
}

