package net.bigpoint.darkorbit.mvc.gui.windows.frozenLabyrinth.model.vo
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableCountDown;
   
   public class FrozenLabyrinthSynkVO
   {
      
      private var _mapName:String = "";
      
      private var _zone:int;
      
      private var _respawnInSeconds:BindableCountDown = new BindableCountDown();
      
      private var _isGateActive:BindableBoolean = new BindableBoolean();
      
      public function FrozenLabyrinthSynkVO()
      {
         super();
      }
      
      public function get mapName() : String
      {
         return this._mapName;
      }
      
      public function set mapName(param1:String) : void
      {
         this._mapName = param1;
      }
      
      public function get zone() : int
      {
         return this._zone;
      }
      
      public function set zone(param1:int) : void
      {
         this._zone = param1;
      }
      
      public function get respawnInSeconds() : BindableCountDown
      {
         return this._respawnInSeconds;
      }
      
      public function get isGateActive() : BindableBoolean
      {
         return this._isGateActive;
      }
      
      public function set isGateActive(param1:BindableBoolean) : void
      {
         this._isGateActive = param1;
      }
   }
}

