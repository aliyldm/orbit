package net.bigpoint.darkorbit.map.model.core
{
   public class EntityTraitBase
   {
      
      private var _owner:MapEntity;
      
      public function EntityTraitBase()
      {
         super();
      }
      
      final public function get owner() : MapEntity
      {
         return this._owner;
      }
      
      final public function set owner(param1:MapEntity) : void
      {
         this._owner = param1;
      }
      
      public function activateTrait() : void
      {
      }
      
      public function deactivateTrait() : void
      {
      }
   }
}

