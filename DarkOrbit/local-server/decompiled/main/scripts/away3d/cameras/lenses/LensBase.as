package away3d.cameras.lenses
{
   import away3d.arcane;
   import away3d.core.math.Matrix3DUtils;
   import away3d.errors.AbstractMethodError;
   import away3d.events.LensEvent;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix3D;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class LensBase extends EventDispatcher
   {
      
      protected var _matrix:Matrix3D;
      
      protected var _scissorRect:Rectangle = new Rectangle();
      
      protected var _viewPort:Rectangle = new Rectangle();
      
      protected var _near:Number = 20;
      
      protected var _far:Number = 3000;
      
      protected var _aspectRatio:Number = 1;
      
      protected var _matrixInvalid:Boolean = true;
      
      protected var _frustumCorners:Vector.<Number> = new Vector.<Number>(8 * 3,true);
      
      private var _unprojection:Matrix3D;
      
      private var _unprojectionInvalid:Boolean = true;
      
      public function LensBase()
      {
         super();
         this._matrix = new Matrix3D();
      }
      
      public function get frustumCorners() : Vector.<Number>
      {
         return this._frustumCorners;
      }
      
      public function set frustumCorners(param1:Vector.<Number>) : void
      {
         this._frustumCorners = param1;
      }
      
      public function get matrix() : Matrix3D
      {
         if(this._matrixInvalid)
         {
            this.updateMatrix();
            this._matrixInvalid = false;
         }
         return this._matrix;
      }
      
      public function set matrix(param1:Matrix3D) : void
      {
         this._matrix = param1;
         this.invalidateMatrix();
      }
      
      public function get near() : Number
      {
         return this._near;
      }
      
      public function set near(param1:Number) : void
      {
         if(param1 == this._near)
         {
            return;
         }
         this._near = param1;
         this.invalidateMatrix();
      }
      
      public function get far() : Number
      {
         return this._far;
      }
      
      public function set far(param1:Number) : void
      {
         if(param1 == this._far)
         {
            return;
         }
         this._far = param1;
         this.invalidateMatrix();
      }
      
      public function project(param1:Vector3D, param2:Vector3D = null) : Vector3D
      {
         if(!param2)
         {
            param2 = new Vector3D();
         }
         Matrix3DUtils.transformVector(this.matrix,param1,param2);
         param2.x /= param2.w;
         param2.y = -param2.y / param2.w;
         param2.z = param1.z;
         return param2;
      }
      
      public function get unprojectionMatrix() : Matrix3D
      {
         if(this._unprojectionInvalid)
         {
            this._unprojection = this._unprojection || new Matrix3D();
            this._unprojection.copyFrom(this.matrix);
            this._unprojection.invert();
            this._unprojectionInvalid = false;
         }
         return this._unprojection;
      }
      
      public function unproject(param1:Number, param2:Number, param3:Number, param4:Vector3D = null) : Vector3D
      {
         throw new AbstractMethodError();
      }
      
      public function clone() : LensBase
      {
         throw new AbstractMethodError();
      }
      
      arcane function get aspectRatio() : Number
      {
         return this._aspectRatio;
      }
      
      arcane function set aspectRatio(param1:Number) : void
      {
         if(this._aspectRatio == param1 || param1 * 0 != 0)
         {
            return;
         }
         this._aspectRatio = param1;
         this.invalidateMatrix();
      }
      
      protected function invalidateMatrix() : void
      {
         this._matrixInvalid = true;
         this._unprojectionInvalid = true;
         dispatchEvent(new LensEvent(LensEvent.MATRIX_CHANGED,this));
      }
      
      protected function updateMatrix() : void
      {
         throw new AbstractMethodError();
      }
      
      arcane function updateScissorRect(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this._scissorRect.x = param1;
         this._scissorRect.y = param2;
         this._scissorRect.width = param3;
         this._scissorRect.height = param4;
         this.invalidateMatrix();
      }
      
      arcane function updateViewport(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this._viewPort.x = param1;
         this._viewPort.y = param2;
         this._viewPort.width = param3;
         this._viewPort.height = param4;
         this.invalidateMatrix();
      }
   }
}

