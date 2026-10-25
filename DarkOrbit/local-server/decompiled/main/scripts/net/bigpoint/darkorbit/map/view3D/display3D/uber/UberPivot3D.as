package net.bigpoint.darkorbit.map.view3D.display3D.uber
{
   import away3d.containers.ObjectContainer3D;
   import com.bigpoint.utils.bindables.BindablePointLite;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   
   public class UberPivot3D extends ObjectContainer3D implements IUpdatable
   {
      
      private static const _vec:Vector.<Number> = new Vector.<Number>(3,true);
      
      private var _pivot:BindablePointLite;
      
      private var _mainContainer:ObjectContainer3D;
      
      public function UberPivot3D(param1:BindablePointLite, param2:ObjectContainer3D)
      {
         super();
         this._pivot = param1;
         this._mainContainer = param2;
      }
      
      public function updateObj(param1:Number) : void
      {
         _vec[0] = _vec[1] = _vec[2] = 0;
         if(scene)
         {
            sceneTransform.transformVectors(_vec,_vec);
            this._mainContainer.inverseSceneTransform.transformVectors(_vec,_vec);
         }
         this._pivot.setTo(_vec[0],-_vec[2],_vec[1]);
      }
   }
}

