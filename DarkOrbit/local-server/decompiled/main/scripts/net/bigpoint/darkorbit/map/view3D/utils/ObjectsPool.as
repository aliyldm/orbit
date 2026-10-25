package net.bigpoint.darkorbit.map.view3D.utils
{
   import away3d.containers.ObjectContainer3D;
   import away3d.entities.Mesh;
   import away3d.entities.ParticleGroup;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.loaders.GeometryLoader;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   
   public class ObjectsPool
   {
      
      private static const DEFAULT_MAX_POOL_SIZE:int = 48;
      
      private static const _pools:Dictionary = new Dictionary();
      
      World3D.instance.resetSignal.add(clearPool);
      
      public function ObjectsPool()
      {
         super();
      }
      
      public static function retrieve(param1:String, param2:int = 1) : Object
      {
         if(_pools[param1] == null)
         {
            _pools[param1] = new Vector.<Object>();
         }
         var _loc3_:Vector.<Object> = _pools[param1];
         var _loc4_:Object = _loc3_.length <= param2 ? null : _loc3_.pop();
         if(_loc4_ is IPoolable)
         {
            (_loc4_ as IPoolable).wakeUp();
         }
         return _loc4_;
      }
      
      public static function free(param1:Object, param2:String) : void
      {
         var _loc3_:Vector.<Object> = null;
         if(param1 == null)
         {
            return;
         }
         if(_pools[param2])
         {
            _loc3_ = _pools[param2];
            if(_loc3_.indexOf(param1) != -1)
            {
               return;
            }
            if(_loc3_.length >= DEFAULT_MAX_POOL_SIZE)
            {
               disposeObject(param1);
               return;
            }
            resetObject(param1);
            _loc3_.push(param1);
            if(param1 is IPoolable)
            {
               (param1 as IPoolable).sleep();
            }
         }
         else
         {
            disposeObject(param1);
         }
      }
      
      public static function clearPool() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:Object = null;
         for(_loc1_ in _pools)
         {
            _loc2_ = _pools[_loc1_];
            while(_loc2_.length > 0)
            {
               _loc3_ = _loc2_.pop();
               if(_loc3_ is IDisposable)
               {
                  (_loc3_ as IDisposable).disposeView();
               }
               else if(_loc3_ is ParticleGroup)
               {
                  (_loc3_ as ParticleGroup).dispose();
               }
            }
            _pools[_loc1_] = null;
            delete _pools[_loc1_];
         }
      }
      
      public static function tracePools() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Vector.<Object> = null;
         for(_loc1_ in _pools)
         {
            _loc2_ = _pools[_loc1_];
            GameFacade.getInstance().sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage("pool " + _loc1_ + " = " + _loc2_.length));
         }
      }
      
      private static function resetObject(param1:Object) : void
      {
         var _loc2_:ObjectContainer3D = null;
         if(param1 is ObjectContainer3D)
         {
            _loc2_ = param1 as ObjectContainer3D;
            _loc2_.visible = true;
            _loc2_.x = _loc2_.y = _loc2_.z = 0;
            _loc2_.rotationX = _loc2_.rotationY = _loc2_.rotationZ = 0;
            _loc2_.scaleX = _loc2_.scaleY = _loc2_.scaleZ = 1;
         }
      }
      
      private static function disposeObject(param1:Object) : void
      {
         var _loc2_:Mesh = null;
         if(param1 is IDisposable)
         {
            (param1 as IDisposable).disposeView();
         }
         else if(param1 is ParticleGroup)
         {
            (param1 as ParticleGroup).dispose();
         }
         else if(param1 is Mesh)
         {
            _loc2_ = param1 as Mesh;
            if(Helper.isCachedMesh(_loc2_))
            {
               _loc2_.animator = null;
               _loc2_.material = null;
               _loc2_.geometry = null;
            }
            else
            {
               GeometryLoader.disposeResource(_loc2_);
            }
         }
      }
   }
}

