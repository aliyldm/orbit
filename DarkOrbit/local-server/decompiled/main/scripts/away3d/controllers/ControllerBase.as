package away3d.controllers
{
   import away3d.arcane;
   import away3d.entities.Entity;
   import away3d.errors.AbstractMethodError;
   
   use namespace arcane;
   
   public class ControllerBase
   {
      
      protected var _autoUpdate:Boolean = true;
      
      protected var _targetObject:Entity;
      
      public function ControllerBase(param1:Entity = null)
      {
         super();
         this.targetObject = param1;
      }
      
      protected function notifyUpdate() : void
      {
         if(Boolean(this._targetObject) && Boolean(this._targetObject.implicitPartition) && this._autoUpdate)
         {
            this._targetObject.implicitPartition.markForUpdate(this._targetObject);
         }
      }
      
      public function get targetObject() : Entity
      {
         return this._targetObject;
      }
      
      public function set targetObject(param1:Entity) : void
      {
         if(this._targetObject == param1)
         {
            return;
         }
         if(Boolean(this._targetObject) && this._autoUpdate)
         {
            this._targetObject._controller = null;
         }
         this._targetObject = param1;
         if(Boolean(this._targetObject) && this._autoUpdate)
         {
            this._targetObject._controller = this;
         }
         this.notifyUpdate();
      }
      
      public function get autoUpdate() : Boolean
      {
         return this._autoUpdate;
      }
      
      public function set autoUpdate(param1:Boolean) : void
      {
         if(this._autoUpdate == param1)
         {
            return;
         }
         this._autoUpdate = param1;
         if(this._targetObject)
         {
            if(this._autoUpdate)
            {
               this._targetObject._controller = this;
            }
            else
            {
               this._targetObject._controller = null;
            }
         }
      }
      
      public function update(param1:Boolean = true) : void
      {
         throw new AbstractMethodError();
      }
   }
}

