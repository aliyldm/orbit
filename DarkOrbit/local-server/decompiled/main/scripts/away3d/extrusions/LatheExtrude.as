package away3d.extrusions
{
   import away3d.bounds.BoundingVolumeBase;
   import away3d.core.base.Geometry;
   import away3d.core.base.SubGeometry;
   import away3d.core.base.SubMesh;
   import away3d.core.base.data.UV;
   import away3d.entities.Mesh;
   import away3d.materials.MaterialBase;
   import away3d.materials.utils.MultipleMaterials;
   import away3d.tools.helpers.MeshHelper;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   public class LatheExtrude extends Mesh
   {
      
      public static const X_AXIS:String = "x";
      
      public static const Y_AXIS:String = "y";
      
      public static const Z_AXIS:String = "z";
      
      private const EPS:Number = 0.0001;
      
      private const LIMIT:uint = 196605;
      
      private const MAXRAD:Number = 1.2;
      
      private var _profile:Vector.<Vector3D>;
      
      private var _lastProfile:Vector.<Vector3D>;
      
      private var _keepLastProfile:Boolean;
      
      private var _axis:String;
      
      private var _revolutions:Number;
      
      private var _subdivision:uint;
      
      private var _offsetRadius:Number;
      
      private var _prevOffsetRadius:Number = 0;
      
      private var _materials:MultipleMaterials;
      
      private var _coverAll:Boolean;
      
      private var _flip:Boolean;
      
      private var _centerMesh:Boolean;
      
      private var _thickness:Number;
      
      private var _preciseThickness:Boolean;
      
      private var _ignoreSides:String;
      
      private var _smoothSurface:Boolean;
      
      private var _tweek:Object;
      
      private var _varr:Vector.<Vector3D>;
      
      private var _varr2:Vector.<Vector3D>;
      
      private var _uvarr:Vector.<UV>;
      
      private var _startRotationOffset:Number = 0;
      
      private var _geomDirty:Boolean = true;
      
      private var _subGeometry:SubGeometry = new SubGeometry();
      
      private var _MaterialsSubGeometries:Vector.<SubGeometryList> = new Vector.<SubGeometryList>();
      
      private var _maxIndProfile:uint;
      
      private var _uva:UV;
      
      private var _uvb:UV;
      
      private var _uvc:UV;
      
      private var _uvd:UV;
      
      private var _va:Vector3D;
      
      private var _vb:Vector3D;
      
      private var _vc:Vector3D;
      
      private var _vd:Vector3D;
      
      private var _uvs:Vector.<Number>;
      
      private var _vertices:Vector.<Number>;
      
      private var _indices:Vector.<uint>;
      
      private var _normals:Vector.<Number>;
      
      private var _normalTmp:Vector3D;
      
      private var _normal0:Vector3D;
      
      private var _normal1:Vector3D;
      
      private var _normal2:Vector3D;
      
      public function LatheExtrude(param1:MaterialBase = null, param2:Vector.<Vector3D> = null, param3:String = "y", param4:Number = 1, param5:uint = 10, param6:Boolean = true, param7:Boolean = false, param8:Boolean = false, param9:Number = 0, param10:Boolean = true, param11:Number = 0, param12:MultipleMaterials = null, param13:String = "", param14:Object = null, param15:Boolean = true)
      {
         var _loc16_:Geometry = new Geometry();
         if(Boolean(!param1) && Boolean(param12) && Boolean(param12.front))
         {
            param1 = param12.front;
         }
         super(_loc16_,param1);
         this._profile = param2;
         this._axis = param3;
         this._revolutions = param4;
         this._subdivision = param5 < 3 ? 3 : param5;
         this._offsetRadius = param11;
         this._materials = param12;
         this._coverAll = param6;
         this._flip = param8;
         this._centerMesh = param7;
         this._thickness = Math.abs(param9);
         this._preciseThickness = param10;
         this._ignoreSides = param13;
         this._tweek = param14;
         this._smoothSurface = param15;
      }
      
      public function get profile() : Vector.<Vector3D>
      {
         return this._profile;
      }
      
      public function set profile(param1:Vector.<Vector3D>) : void
      {
         if(param1.length > 1)
         {
            this._profile = param1;
            this.invalidateGeometry();
            return;
         }
         throw new Error("LatheExtrude error: the profile Vector.<Vector3D> must hold a mimimun of 2 vector3D\'s");
      }
      
      public function get startRotationOffset() : Number
      {
         return this._startRotationOffset;
      }
      
      public function set startRotationOffset(param1:Number) : void
      {
         this._startRotationOffset = param1;
      }
      
      public function get axis() : String
      {
         return this._axis;
      }
      
      public function set axis(param1:String) : void
      {
         if(this._axis == param1)
         {
            return;
         }
         this._axis = param1;
         this.invalidateGeometry();
      }
      
      public function get revolutions() : Number
      {
         return this._revolutions;
      }
      
      public function set revolutions(param1:Number) : void
      {
         if(this._revolutions == param1)
         {
            return;
         }
         this._revolutions = this._revolutions > 0.001 ? this._revolutions : 0.001;
         this._revolutions = param1;
         this.invalidateGeometry();
      }
      
      public function get subdivision() : uint
      {
         return this._subdivision;
      }
      
      public function set subdivision(param1:uint) : void
      {
         param1 = param1 < 3 ? 3 : param1;
         if(this._subdivision == param1)
         {
            return;
         }
         this._subdivision = param1;
         this.invalidateGeometry();
      }
      
      public function get offsetRadius() : Number
      {
         return this._offsetRadius;
      }
      
      public function set offsetRadius(param1:Number) : void
      {
         if(this._offsetRadius == param1)
         {
            return;
         }
         this._offsetRadius = param1;
         this.invalidateGeometry();
      }
      
      public function get materials() : MultipleMaterials
      {
         return this._materials;
      }
      
      public function set materials(param1:MultipleMaterials) : void
      {
         this._materials = param1;
         if(Boolean(this._materials.front) && this.material != this._materials.front)
         {
            this.material = this._materials.front;
         }
         this.invalidateGeometry();
      }
      
      public function get coverAll() : Boolean
      {
         return this._coverAll;
      }
      
      public function set coverAll(param1:Boolean) : void
      {
         if(this._coverAll == param1)
         {
            return;
         }
         this._coverAll = param1;
         this.invalidateGeometry();
      }
      
      public function get flip() : Boolean
      {
         return this._flip;
      }
      
      public function set flip(param1:Boolean) : void
      {
         if(this._flip == param1)
         {
            return;
         }
         this._flip = param1;
         this.invalidateGeometry();
      }
      
      public function get smoothSurface() : Boolean
      {
         return this._smoothSurface;
      }
      
      public function set smoothSurface(param1:Boolean) : void
      {
         if(this._smoothSurface == param1)
         {
            return;
         }
         this._smoothSurface = param1;
         this._geomDirty = true;
      }
      
      public function get keepLastProfile() : Boolean
      {
         return this._keepLastProfile;
      }
      
      public function set keepLastProfile(param1:Boolean) : void
      {
         if(this._keepLastProfile == param1)
         {
            return;
         }
         this._keepLastProfile = param1;
      }
      
      public function get lastProfile() : Vector.<Vector3D>
      {
         if(this.keepLastProfile && !this._lastProfile)
         {
            this.buildExtrude();
         }
         return this._lastProfile;
      }
      
      public function get preciseThickness() : Boolean
      {
         return this._preciseThickness;
      }
      
      public function set preciseThickness(param1:Boolean) : void
      {
         if(this._preciseThickness == param1)
         {
            return;
         }
         this._preciseThickness = param1;
         this.invalidateGeometry();
      }
      
      public function get centerMesh() : Boolean
      {
         return this._centerMesh;
      }
      
      public function set centerMesh(param1:Boolean) : void
      {
         if(this._centerMesh == param1)
         {
            return;
         }
         this._centerMesh = param1;
         if(this._centerMesh && this._subGeometry.vertexData.length > 0)
         {
            MeshHelper.recenter(this);
         }
         else
         {
            this.invalidateGeometry();
         }
      }
      
      public function get thickness() : Number
      {
         return this._thickness;
      }
      
      public function set thickness(param1:Number) : void
      {
         if(this._thickness == param1)
         {
            return;
         }
         this._thickness = param1 > 0 ? param1 : this._thickness;
         this.invalidateGeometry();
      }
      
      public function get ignoreSides() : String
      {
         return this._ignoreSides;
      }
      
      public function set ignoreSides(param1:String) : void
      {
         this._ignoreSides = param1;
         this.invalidateGeometry();
      }
      
      public function get tweek() : Object
      {
         return this._tweek;
      }
      
      public function set tweek(param1:Object) : void
      {
         this._tweek = param1;
         this.invalidateGeometry();
      }
      
      override public function get bounds() : BoundingVolumeBase
      {
         if(this._geomDirty)
         {
            this.buildExtrude();
         }
         return super.bounds;
      }
      
      override public function get geometry() : Geometry
      {
         if(this._geomDirty)
         {
            this.buildExtrude();
         }
         return super.geometry;
      }
      
      override public function get subMeshes() : Vector.<SubMesh>
      {
         if(this._geomDirty)
         {
            this.buildExtrude();
         }
         return super.subMeshes;
      }
      
      private function closeTopBottom(param1:int, param2:RenderSide) : void
      {
         var _loc3_:Vector3D = null;
         var _loc4_:Vector3D = null;
         var _loc5_:Vector3D = null;
         var _loc6_:Vector3D = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:uint = this._varr.length - param1;
         this._uva.u = this._uvb.u = 0;
         this._uvc.u = this._uvd.u = 1;
         _loc7_ = 0;
         while(_loc7_ < _loc11_)
         {
            if(_loc7_ != 0)
            {
               if(this._coverAll)
               {
                  _loc9_ = _loc7_ / _loc11_;
                  _loc10_ = (_loc7_ + param1) / _loc11_;
                  this._uva.v = _loc9_;
                  this._uvb.v = _loc10_;
                  this._uvc.v = _loc10_;
                  this._uvd.v = _loc9_;
               }
               else
               {
                  this._uva.v = 0;
                  this._uvb.v = 1;
                  this._uvc.v = 1;
                  this._uvd.v = 0;
               }
               if(param2.top)
               {
                  _loc3_ = this._varr[_loc7_];
                  _loc4_ = this._varr[_loc7_ + param1];
                  _loc5_ = this._varr2[_loc7_ + param1];
                  _loc6_ = this._varr2[_loc7_];
                  if(this._flip)
                  {
                     this.addFace(_loc4_,_loc3_,_loc5_,this._uvb,this._uva,this._uvc,4);
                     this.addFace(_loc5_,_loc3_,_loc6_,this._uvc,this._uva,this._uvd,4);
                  }
                  else
                  {
                     this.addFace(_loc3_,_loc4_,_loc5_,this._uva,this._uvb,this._uvc,4);
                     this.addFace(_loc3_,_loc5_,_loc6_,this._uva,this._uvc,this._uvd,4);
                  }
               }
               if(param2.bottom)
               {
                  _loc8_ = _loc7_ + param1 - 1;
                  _loc3_ = this._varr[_loc8_];
                  _loc4_ = this._varr[_loc8_ + param1];
                  _loc5_ = this._varr2[_loc8_ + param1];
                  _loc6_ = this._varr2[_loc8_];
                  if(this._flip)
                  {
                     this.addFace(_loc3_,_loc4_,_loc5_,this._uva,this._uvb,this._uvc,5);
                     this.addFace(_loc3_,_loc5_,_loc6_,this._uva,this._uvc,this._uvd,5);
                  }
                  else
                  {
                     this.addFace(_loc4_,_loc3_,_loc5_,this._uvb,this._uva,this._uvc,5);
                     this.addFace(_loc5_,_loc3_,_loc6_,this._uvc,this._uva,this._uvd,5);
                  }
               }
            }
            _loc7_ += param1;
         }
      }
      
      private function closeSides(param1:uint, param2:RenderSide) : void
      {
         var _loc3_:Vector3D = null;
         var _loc4_:Vector3D = null;
         var _loc5_:Vector3D = null;
         var _loc6_:Vector3D = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc7_:uint = this._varr.length - param1;
         var _loc12_:int = param1 - 1;
         var _loc13_:Number = this._preciseThickness && param1 % 2 == 0 ? 1 / _loc12_ : 1 / param1;
         _loc8_ = 0;
         while(_loc8_ < _loc12_)
         {
            if(this._coverAll)
            {
               _loc10_ = _loc8_ * _loc13_;
               _loc11_ = _loc10_ + _loc13_;
               this._uva.v = 1 - _loc10_;
               this._uvb.v = 1 - _loc11_;
               this._uvc.v = 1 - _loc11_;
               this._uvd.v = 1 - _loc10_;
            }
            else
            {
               this._uva.v = 0;
               this._uvb.v = 1;
               this._uvc.v = 1;
               this._uvd.v = 0;
            }
            if(param2.left)
            {
               _loc3_ = this._varr[_loc8_ + 1];
               _loc4_ = this._varr[_loc8_];
               _loc5_ = this._varr2[_loc8_];
               _loc6_ = this._varr2[_loc8_ + 1];
               this._uva.u = this._uvb.u = 0;
               this._uvc.u = this._uvd.u = 1;
               if(this._flip)
               {
                  this.addFace(_loc4_,_loc3_,_loc5_,this._uvb,this._uva,this._uvc,2);
                  this.addFace(_loc5_,_loc3_,_loc6_,this._uvc,this._uva,this._uvd,2);
               }
               else
               {
                  this.addFace(_loc3_,_loc4_,_loc5_,this._uva,this._uvb,this._uvc,2);
                  this.addFace(_loc3_,_loc5_,_loc6_,this._uva,this._uvc,this._uvd,2);
               }
            }
            if(param2.right)
            {
               _loc9_ = _loc7_ + _loc8_;
               _loc3_ = this._varr[_loc9_ + 1];
               _loc4_ = this._varr[_loc9_];
               _loc5_ = this._varr2[_loc9_];
               _loc6_ = this._varr2[_loc9_ + 1];
               this._uva.u = this._uvb.u = 1;
               this._uvc.u = this._uvd.u = 0;
               if(this._flip)
               {
                  this.addFace(_loc3_,_loc4_,_loc5_,this._uva,this._uvb,this._uvc,3);
                  this.addFace(_loc3_,_loc5_,_loc6_,this._uva,this._uvc,this._uvd,3);
               }
               else
               {
                  this.addFace(_loc4_,_loc3_,_loc5_,this._uvb,this._uva,this._uvc,3);
                  this.addFace(_loc5_,_loc3_,_loc6_,this._uvc,this._uva,this._uvd,3);
               }
            }
            _loc8_++;
         }
      }
      
      private function generate(param1:Vector.<Vector3D>, param2:String, param3:Object, param4:Boolean = true, param5:uint = 0) : void
      {
         var _loc8_:uint = 0;
         var _loc14_:Vector.<Vector3D> = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:uint = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:Vector3D = null;
         var _loc27_:Vector3D = null;
         var _loc28_:Vector3D = null;
         var _loc29_:Vector3D = null;
         var _loc30_:UV = null;
         var _loc31_:UV = null;
         var _loc32_:UV = null;
         var _loc33_:UV = null;
         var _loc34_:uint = 0;
         var _loc35_:uint = 0;
         var _loc36_:int = 0;
         param2 = param2;
         if(!param3)
         {
            param3 = {};
         }
         if(isNaN(param3[X_AXIS]) || !param3[X_AXIS])
         {
            param3[X_AXIS] = 0;
         }
         if(isNaN(param3[Y_AXIS]) || !param3[Y_AXIS])
         {
            param3[Y_AXIS] = 0;
         }
         if(isNaN(param3[Z_AXIS]) || !param3[Z_AXIS])
         {
            param3[Z_AXIS] = 0;
         }
         if(isNaN(param3["radius"]) || !param3["radius"])
         {
            param3["radius"] = 0;
         }
         var _loc6_:Number = this._startRotationOffset;
         var _loc7_:Number = 360 / this._subdivision;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc11_:Number = 0;
         var _loc12_:Number = 0;
         var _loc13_:Number = 0;
         var _loc15_:Array = [];
         if(!this._varr)
         {
            this._varr = new Vector.<Vector3D>();
         }
         _loc18_ = 0;
         while(_loc18_ < param1.length)
         {
            this._varr.push(new Vector3D(param1[_loc18_].x,param1[_loc18_].y,param1[_loc18_].z));
            this._uvarr.push(new UV(0,1 % _loc18_));
            _loc18_++;
         }
         var _loc19_:Number = -this._offsetRadius;
         _loc19_ = _loc19_ + this._prevOffsetRadius;
         var _loc20_:Number = 0;
         var _loc21_:Number = 360 * this._revolutions;
         var _loc22_:Number = this._revolutions < 1 ? this._subdivision : this._subdivision * this._revolutions;
         if(this._revolutions < 1)
         {
            _loc7_ *= this._revolutions;
         }
         _loc18_ = 0;
         while(_loc18_ <= _loc22_)
         {
            _loc14_ = new Vector.<Vector3D>();
            _loc14_ = param1.concat();
            _loc8_ = 0;
            while(_loc8_ < _loc14_.length)
            {
               _loc20_ = (this._revolutions - 1) / (this._varr.length + 1);
               if(param3[X_AXIS] != 0)
               {
                  _loc9_ += param3[X_AXIS] * _loc20_ / this._revolutions;
               }
               if(param3[Y_AXIS] != 0)
               {
                  _loc10_ += param3[Y_AXIS] * _loc20_ / this._revolutions;
               }
               if(param3[Z_AXIS] != 0)
               {
                  _loc11_ += param3[Z_AXIS] * _loc20_ / this._revolutions;
               }
               if(param3.radius != 0)
               {
                  _loc12_ += param3.radius / (this._varr.length + 1);
               }
               if(param3.rotation != 0)
               {
                  _loc13_ += 360 / (param3.rotation * this._subdivision);
               }
               if(this._axis == X_AXIS)
               {
                  if(_loc18_ == 0)
                  {
                     _loc15_[_loc8_] = _loc19_ - Math.abs(_loc14_[_loc8_].z);
                  }
                  _loc14_[_loc8_].z = Math.cos(-_loc6_ / 180 * Math.PI) * (_loc15_[_loc8_] + _loc12_);
                  _loc14_[_loc8_].y = Math.sin(_loc6_ / 180 * Math.PI) * (_loc15_[_loc8_] + _loc12_);
                  if(_loc18_ == 0)
                  {
                     this._varr[_loc8_].z += _loc14_[_loc8_].z;
                     this._varr[_loc8_].y += _loc14_[_loc8_].y;
                  }
               }
               else if(this._axis == Y_AXIS)
               {
                  if(_loc18_ == 0)
                  {
                     _loc15_[_loc8_] = _loc19_ - Math.abs(_loc14_[_loc8_].x);
                  }
                  _loc14_[_loc8_].x = Math.cos(-_loc6_ / 180 * Math.PI) * (_loc15_[_loc8_] + _loc12_);
                  _loc14_[_loc8_].z = Math.sin(_loc6_ / 180 * Math.PI) * (_loc15_[_loc8_] + _loc12_);
                  if(_loc18_ == 0)
                  {
                     this._varr[_loc8_].x = _loc14_[_loc8_].x;
                     this._varr[_loc8_].z = _loc14_[_loc8_].z;
                  }
               }
               else
               {
                  if(_loc18_ == 0)
                  {
                     _loc15_[_loc8_] = _loc19_ - Math.abs(_loc14_[_loc8_].y);
                  }
                  _loc14_[_loc8_].x = Math.cos(-_loc6_ / 180 * Math.PI) * (_loc15_[_loc8_] + _loc12_);
                  _loc14_[_loc8_].y = Math.sin(_loc6_ / 180 * Math.PI) * (_loc15_[_loc8_] + _loc12_);
                  if(_loc18_ == 0)
                  {
                     this._varr[_loc8_].x = _loc14_[_loc8_].x;
                     this._varr[_loc8_].y = _loc14_[_loc8_].y;
                  }
               }
               _loc14_[_loc8_].x += _loc9_;
               _loc14_[_loc8_].y += _loc10_;
               _loc14_[_loc8_].z += _loc11_;
               this._varr.push(new Vector3D(_loc14_[_loc8_].x,_loc14_[_loc8_].y,_loc14_[_loc8_].z));
               if(this._coverAll)
               {
                  _loc16_ = _loc6_ / _loc21_;
               }
               else
               {
                  _loc16_ = _loc18_ % 2 == 0 ? 0 : 1;
               }
               _loc17_ = _loc8_ / (this._profile.length - 1);
               this._uvarr.push(new UV(_loc16_,_loc17_));
               _loc8_++;
            }
            _loc6_ += _loc7_;
            _loc18_++;
         }
         this._prevOffsetRadius = this._offsetRadius;
         if(param4)
         {
            _loc24_ = int(param1.length);
            _loc25_ = this._varr.length - _loc24_;
            _loc36_ = _loc24_ - 1;
            _loc18_ = 0;
            while(_loc18_ < _loc25_)
            {
               _loc23_ = 0;
               _loc8_ = 0;
               while(_loc8_ < _loc36_)
               {
                  if(_loc18_ > 0)
                  {
                     _loc35_ = _loc34_ = _loc18_ + _loc23_;
                     _loc30_ = this._uvarr[_loc34_ + 1];
                     _loc31_ = this._uvarr[_loc34_];
                     _loc32_ = this._uvarr[_loc34_ + _loc24_];
                     _loc33_ = this._uvarr[_loc34_ + _loc24_ + 1];
                     if(this._revolutions == 1 && _loc18_ + _loc24_ == _loc25_ && this._tweek == null)
                     {
                        _loc26_ = this._varr[_loc35_ + 1];
                        _loc27_ = this._varr[_loc35_];
                        _loc28_ = this._varr[_loc35_ + _loc24_];
                        _loc29_ = this._varr[_loc35_ + _loc24_ + 1];
                     }
                     else
                     {
                        _loc26_ = this._varr[_loc35_ + 1];
                        _loc27_ = this._varr[_loc35_];
                        _loc28_ = this._varr[_loc35_ + _loc24_];
                        _loc29_ = this._varr[_loc35_ + _loc24_ + 1];
                     }
                     if(this._flip)
                     {
                        if(param5 == 1)
                        {
                           this._uva.u = 1 - _loc30_.u;
                           this._uva.v = _loc30_.v;
                           this._uvb.u = 1 - _loc31_.u;
                           this._uvb.v = _loc31_.v;
                           this._uvc.u = 1 - _loc32_.u;
                           this._uvc.v = _loc32_.v;
                           this._uvd.u = 1 - _loc33_.u;
                           this._uvd.v = _loc33_.v;
                           this.addFace(_loc26_,_loc27_,_loc28_,this._uva,this._uvb,this._uvc,param5);
                           this.addFace(_loc26_,_loc28_,_loc29_,this._uva,this._uvc,this._uvd,param5);
                        }
                        else
                        {
                           this.addFace(_loc27_,_loc26_,_loc28_,_loc31_,_loc30_,_loc32_,param5);
                           this.addFace(_loc28_,_loc26_,_loc29_,_loc32_,_loc30_,_loc33_,param5);
                        }
                     }
                     else if(param5 == 1)
                     {
                        this._uva.u = _loc30_.u;
                        this._uva.v = 1 - _loc30_.v;
                        this._uvb.u = _loc31_.u;
                        this._uvb.v = 1 - _loc31_.v;
                        this._uvc.u = _loc32_.u;
                        this._uvc.v = 1 - _loc32_.v;
                        this._uvd.u = _loc33_.u;
                        this._uvd.v = 1 - _loc33_.v;
                        this.addFace(_loc27_,_loc26_,_loc28_,this._uvb,this._uva,this._uvc,param5);
                        this.addFace(_loc28_,_loc26_,_loc29_,this._uvc,this._uva,this._uvd,param5);
                     }
                     else
                     {
                        this.addFace(_loc26_,_loc27_,_loc28_,_loc30_,_loc31_,_loc32_,param5);
                        this.addFace(_loc26_,_loc28_,_loc29_,_loc30_,_loc32_,_loc33_,param5);
                     }
                  }
                  _loc23_++;
                  _loc8_++;
               }
               _loc18_ += _loc24_;
            }
         }
      }
      
      private function buildExtrude() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Array = null;
         var _loc3_:RenderSide = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:FourPoints = null;
         var _loc9_:Vector3D = null;
         var _loc10_:Vector3D = null;
         var _loc11_:Vector3D = null;
         var _loc12_:Vector3D = null;
         var _loc13_:Vector.<Vector3D> = null;
         var _loc14_:Vector.<Vector3D> = null;
         var _loc15_:Vector.<Vector3D> = null;
         var _loc16_:Vector.<Vector3D> = null;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:SubGeometryList = null;
         var _loc20_:SubGeometry = null;
         if(!this._profile)
         {
            throw new Error("LatheExtrude error: No profile Vector.<Vector3D> set");
         }
         this._MaterialsSubGeometries = null;
         this._geomDirty = false;
         this.initHolders();
         this._maxIndProfile = this._profile.length * 9;
         if(this._profile.length > 1)
         {
            if(this._thickness != 0)
            {
               _loc2_ = ["top","bottom","right","left","front","back"];
               _loc3_ = new RenderSide();
               _loc1_ = 0;
               while(_loc1_ < _loc2_.length)
               {
                  _loc3_[_loc2_[_loc1_]] = this._ignoreSides.indexOf(_loc2_[_loc1_]) == -1;
                  _loc1_++;
               }
               this._varr = new Vector.<Vector3D>();
               this._varr2 = new Vector.<Vector3D>();
               if(this._preciseThickness)
               {
                  switch(this._axis)
                  {
                     case X_AXIS:
                        _loc4_ = X_AXIS;
                        _loc5_ = Z_AXIS;
                        _loc6_ = Y_AXIS;
                        break;
                     case Y_AXIS:
                        _loc4_ = Y_AXIS;
                        _loc5_ = X_AXIS;
                        _loc6_ = Z_AXIS;
                        break;
                     case Z_AXIS:
                        _loc4_ = Z_AXIS;
                        _loc5_ = Y_AXIS;
                        _loc6_ = X_AXIS;
                  }
                  _loc7_ = this.buildThicknessPoints(this._profile,this.thickness,_loc4_,_loc5_);
                  _loc13_ = new Vector.<Vector3D>();
                  _loc14_ = new Vector.<Vector3D>();
                  _loc1_ = 0;
                  while(_loc1_ < _loc7_.length)
                  {
                     _loc8_ = _loc7_[_loc1_];
                     _loc9_ = new Vector3D();
                     _loc10_ = new Vector3D();
                     if(_loc1_ == 0)
                     {
                        _loc9_[_loc4_] = _loc8_.pt2.x;
                        _loc9_[_loc5_] = _loc8_.pt2.y;
                        _loc9_[_loc6_] = this._profile[0][_loc6_];
                        _loc13_.push(_loc9_);
                        _loc10_[_loc4_] = _loc8_.pt1.x;
                        _loc10_[_loc5_] = _loc8_.pt1.y;
                        _loc10_[_loc6_] = this._profile[0][_loc6_];
                        _loc14_.push(_loc10_);
                        if(_loc7_.length == 1)
                        {
                           _loc11_ = new Vector3D();
                           _loc12_ = new Vector3D();
                           _loc11_[_loc4_] = _loc8_.pt4.x;
                           _loc11_[_loc5_] = _loc8_.pt4.y;
                           _loc11_[_loc6_] = this._profile[0][_loc6_];
                           _loc13_.push(_loc11_);
                           _loc12_[_loc4_] = _loc8_.pt3.x;
                           _loc12_[_loc5_] = _loc8_.pt3.y;
                           _loc12_[_loc6_] = this._profile[0][_loc6_];
                           _loc14_.push(_loc12_);
                        }
                     }
                     else if(_loc1_ == _loc7_.length - 1)
                     {
                        _loc9_[_loc4_] = _loc8_.pt2.x;
                        _loc9_[_loc5_] = _loc8_.pt2.y;
                        _loc9_[_loc6_] = this._profile[_loc1_][_loc6_];
                        _loc13_.push(_loc9_);
                        _loc10_[_loc4_] = _loc8_.pt1.x;
                        _loc10_[_loc5_] = _loc8_.pt1.y;
                        _loc10_[_loc6_] = this._profile[_loc1_][_loc6_];
                        _loc14_.push(_loc10_);
                        _loc11_ = new Vector3D();
                        _loc12_ = new Vector3D();
                        _loc11_[_loc4_] = _loc8_.pt4.x;
                        _loc11_[_loc5_] = _loc8_.pt4.y;
                        _loc11_[_loc6_] = this._profile[_loc1_][_loc6_];
                        _loc13_.push(_loc11_);
                        _loc12_[_loc4_] = _loc8_.pt3.x;
                        _loc12_[_loc5_] = _loc8_.pt3.y;
                        _loc12_[_loc6_] = this._profile[_loc1_][_loc6_];
                        _loc14_.push(_loc12_);
                     }
                     else
                     {
                        _loc9_[_loc4_] = _loc8_.pt2.x;
                        _loc9_[_loc5_] = _loc8_.pt2.y;
                        _loc9_[_loc6_] = this._profile[_loc1_][_loc6_];
                        _loc13_.push(_loc9_);
                        _loc10_[_loc4_] = _loc8_.pt1.x;
                        _loc10_[_loc5_] = _loc8_.pt1.y;
                        _loc10_[_loc6_] = this._profile[_loc1_][_loc6_];
                        _loc14_.push(_loc10_);
                     }
                     _loc1_++;
                  }
                  this.generate(_loc13_,this._axis,this._tweek,_loc3_.front,0);
                  this._varr2 = this._varr2.concat(this._varr);
                  this._varr = new Vector.<Vector3D>();
                  this.generate(_loc14_,this._axis,this._tweek,_loc3_.back,1);
               }
               else
               {
                  _loc15_ = new Vector.<Vector3D>();
                  _loc16_ = new Vector.<Vector3D>();
                  _loc17_ = this._thickness * 0.5;
                  _loc1_ = 0;
                  while(_loc1_ < this._profile.length)
                  {
                     switch(this._axis)
                     {
                        case X_AXIS:
                           _loc18_ = this._profile[_loc1_].z < 0 ? _loc17_ : -_loc17_;
                           _loc15_.push(new Vector3D(this._profile[_loc1_].x,this._profile[_loc1_].y,this._profile[_loc1_].z - _loc18_));
                           _loc16_.push(new Vector3D(this._profile[_loc1_].x,this._profile[_loc1_].y,this._profile[_loc1_].z + _loc18_));
                           break;
                        case Y_AXIS:
                           _loc18_ = this._profile[_loc1_].x < 0 ? _loc17_ : -_loc17_;
                           _loc15_.push(new Vector3D(this._profile[_loc1_].x - _loc18_,this._profile[_loc1_].y,this._profile[_loc1_].z));
                           _loc16_.push(new Vector3D(this._profile[_loc1_].x + _loc18_,this._profile[_loc1_].y,this._profile[_loc1_].z));
                           break;
                        case Z_AXIS:
                           _loc18_ = this._profile[_loc1_].y < 0 ? _loc17_ : -_loc17_;
                           _loc15_.push(new Vector3D(this._profile[_loc1_].x,this._profile[_loc1_].y - _loc18_,this._profile[_loc1_].z));
                           _loc16_.push(new Vector3D(this._profile[_loc1_].x,this._profile[_loc1_].y + _loc18_,this._profile[_loc1_].z));
                     }
                     _loc1_++;
                  }
                  this.generate(_loc15_,this._axis,this._tweek,_loc3_.front,0);
                  this._varr2 = this._varr2.concat(this._varr);
                  this._varr = new Vector.<Vector3D>();
                  this.generate(_loc16_,this._axis,this._tweek,_loc3_.back,1);
               }
               this.closeTopBottom(this._profile.length,_loc3_);
               if(this._revolutions != 1)
               {
                  this.closeSides(this._profile.length,_loc3_);
               }
            }
            else
            {
               this.generate(this._profile,this._axis,this._tweek);
            }
            if(this._vertices.length > 0)
            {
               this._subGeometry.updateVertexData(this._vertices);
               this._subGeometry.updateIndexData(this._indices);
               this._subGeometry.updateUVData(this._uvs);
               if(this._smoothSurface)
               {
                  this._subGeometry.updateVertexNormalData(this._normals);
               }
               this.geometry.addSubGeometry(this._subGeometry);
            }
            if(Boolean(this._MaterialsSubGeometries) && this._MaterialsSubGeometries.length > 0)
            {
               _loc1_ = 1;
               while(_loc1_ < 6)
               {
                  _loc19_ = this._MaterialsSubGeometries[_loc1_];
                  _loc20_ = _loc19_.subGeometry;
                  if((Boolean(_loc20_)) && _loc19_.vertices.length > 0)
                  {
                     this.geometry.addSubGeometry(_loc20_);
                     this.subMeshes[this.subMeshes.length - 1].material = _loc19_.material;
                     _loc20_.updateVertexData(_loc19_.vertices);
                     _loc20_.updateIndexData(_loc19_.indices);
                     _loc20_.updateUVData(_loc19_.uvs);
                     if(this._smoothSurface)
                     {
                        _loc20_.updateVertexNormalData(_loc19_.normals);
                     }
                  }
                  _loc1_++;
               }
            }
            if(this._keepLastProfile)
            {
               this._lastProfile = this._varr.splice(this._varr.length - this._profile.length,this._profile.length);
            }
            else
            {
               this._lastProfile = null;
            }
            this._varr = this._varr2 = null;
            this._uvarr = null;
            if(this._centerMesh)
            {
               MeshHelper.recenter(this);
            }
            return;
         }
         throw new Error("LatheExtrude error: the profile Vector.<Vector3D> must hold a mimimun of 2 vector3D\'s");
      }
      
      private function calcNormal(param1:Vector3D, param2:Vector3D, param3:Vector3D) : void
      {
         var _loc4_:Number = param3.x - param1.x;
         var _loc5_:Number = param3.y - param1.y;
         var _loc6_:Number = param3.z - param1.z;
         var _loc7_:Number = param2.x - param1.x;
         var _loc8_:Number = param2.y - param1.y;
         var _loc9_:Number = param2.z - param1.z;
         var _loc10_:Number = _loc6_ * _loc8_ - _loc5_ * _loc9_;
         var _loc11_:Number = _loc4_ * _loc9_ - _loc6_ * _loc7_;
         var _loc12_:Number = _loc5_ * _loc7_ - _loc4_ * _loc8_;
         var _loc13_:Number = 1 / Math.sqrt(_loc10_ * _loc10_ + _loc11_ * _loc11_ + _loc12_ * _loc12_);
         this._normal0.x = this._normal1.x = this._normal2.x = _loc10_ * _loc13_;
         this._normal0.y = this._normal1.y = this._normal2.y = _loc11_ * _loc13_;
         this._normal0.z = this._normal1.z = this._normal2.z = _loc12_ * _loc13_;
      }
      
      private function addFace(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:UV, param5:UV, param6:UV, param7:uint) : void
      {
         var _loc8_:SubGeometry = null;
         var _loc9_:Vector.<Number> = null;
         var _loc10_:Vector.<Number> = null;
         var _loc11_:Vector.<Number> = null;
         var _loc12_:Vector.<uint> = null;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = false;
         var _loc15_:Boolean = false;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:uint = 0;
         var _loc24_:uint = 0;
         var _loc25_:uint = 0;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:uint = 0;
         var _loc29_:uint = 0;
         if(Boolean(param7 > 0) && Boolean(this._MaterialsSubGeometries) && this._MaterialsSubGeometries.length > 0)
         {
            _loc8_ = this._MaterialsSubGeometries[param7].subGeometry;
            _loc9_ = this._MaterialsSubGeometries[param7].uvs;
            _loc11_ = this._MaterialsSubGeometries[param7].vertices;
            _loc12_ = this._MaterialsSubGeometries[param7].indices;
            _loc10_ = this._MaterialsSubGeometries[param7].normals;
         }
         else
         {
            _loc8_ = this._subGeometry;
            _loc9_ = this._uvs;
            _loc11_ = this._vertices;
            _loc12_ = this._indices;
            _loc10_ = this._normals;
         }
         if(_loc11_.length + 9 > this.LIMIT)
         {
            _loc8_.updateVertexData(_loc11_);
            _loc8_.updateIndexData(_loc12_);
            _loc8_.updateUVData(_loc9_);
            if(this._smoothSurface)
            {
               _loc8_.updateVertexNormalData(_loc10_);
            }
            this.geometry.addSubGeometry(_loc8_);
            if(Boolean(param7 > 0) && Boolean(this._MaterialsSubGeometries) && Boolean(this._MaterialsSubGeometries[param7].subGeometry))
            {
               this.subMeshes[this.subMeshes.length - 1].material = this._MaterialsSubGeometries[param7].material;
            }
            _loc8_ = new SubGeometry();
            _loc8_.autoDeriveVertexTangents = true;
            if(Boolean(this._MaterialsSubGeometries) && this._MaterialsSubGeometries.length > 0)
            {
               this._MaterialsSubGeometries[param7].subGeometry = _loc8_;
               _loc9_ = new Vector.<Number>();
               _loc11_ = new Vector.<Number>();
               _loc12_ = new Vector.<uint>();
               _loc10_ = new Vector.<Number>();
               this._MaterialsSubGeometries[param7].uvs = _loc9_;
               this._MaterialsSubGeometries[param7].indices = _loc12_;
               if(this._smoothSurface)
               {
                  this._MaterialsSubGeometries[param7].normals = _loc10_;
               }
               else
               {
                  _loc8_.autoDeriveVertexNormals = true;
               }
               if(param7 == 0)
               {
                  this._subGeometry = _loc8_;
                  this._uvs = _loc9_;
                  this._vertices = _loc11_;
                  this._indices = _loc12_;
                  this._normals = _loc10_;
               }
            }
            else
            {
               this._subGeometry = _loc8_;
               this._uvs = new Vector.<Number>();
               this._vertices = new Vector.<Number>();
               this._indices = new Vector.<uint>();
               this._normals = new Vector.<Number>();
               _loc9_ = this._uvs;
               _loc11_ = this._vertices;
               _loc12_ = this._indices;
               _loc10_ = this._normals;
            }
         }
         if(this._smoothSurface)
         {
            _loc25_ = _loc12_.length;
            this.calcNormal(param1,param2,param3);
            if(_loc25_ > 0)
            {
               _loc27_ = _loc25_ - this._maxIndProfile;
               _loc28_ = _loc27_ < 0 ? 0 : uint(_loc27_);
               _loc29_ = _loc25_ - 1;
               for(; _loc29_ > _loc28_; _loc29_--)
               {
                  _loc24_ = _loc12_[_loc29_];
                  _loc21_ = _loc24_ * 3;
                  _loc22_ = _loc21_ + 1;
                  _loc23_ = _loc21_ + 2;
                  _loc19_ = _loc24_ * 2;
                  _loc20_ = _loc19_ + 1;
                  if(_loc13_ && _loc14_ && _loc15_)
                  {
                     break;
                  }
                  if(!_loc13_ && _loc11_[_loc21_] == param1.x && _loc11_[_loc22_] == param1.y && _loc11_[_loc23_] == param1.z)
                  {
                     this._normalTmp.x = _loc10_[_loc21_];
                     this._normalTmp.y = _loc10_[_loc22_];
                     this._normalTmp.z = _loc10_[_loc23_];
                     _loc26_ = Vector3D.angleBetween(this._normalTmp,this._normal0);
                     if(_loc26_ < this.MAXRAD)
                     {
                        this._normal0.x = (this._normalTmp.x + this._normal0.x) * 0.5;
                        this._normal0.y = (this._normalTmp.y + this._normal0.y) * 0.5;
                        this._normal0.z = (this._normalTmp.z + this._normal0.z) * 0.5;
                        if(_loc9_[_loc19_] == param4.u && _loc9_[_loc20_] == param4.v)
                        {
                           _loc13_ = true;
                           _loc16_ = _loc24_;
                           continue;
                        }
                     }
                  }
                  if(!_loc14_ && _loc11_[_loc21_] == param2.x && _loc11_[_loc22_] == param2.y && _loc11_[_loc23_] == param2.z)
                  {
                     this._normalTmp.x = _loc10_[_loc21_];
                     this._normalTmp.y = _loc10_[_loc22_];
                     this._normalTmp.z = _loc10_[_loc23_];
                     _loc26_ = Vector3D.angleBetween(this._normalTmp,this._normal1);
                     if(_loc26_ < this.MAXRAD)
                     {
                        this._normal1.x = (this._normalTmp.x + this._normal1.x) * 0.5;
                        this._normal1.y = (this._normalTmp.y + this._normal1.y) * 0.5;
                        this._normal1.z = (this._normalTmp.z + this._normal1.z) * 0.5;
                        if(_loc9_[_loc19_] == param5.u && _loc9_[_loc20_] == param5.v)
                        {
                           _loc14_ = true;
                           _loc17_ = _loc24_;
                           continue;
                        }
                     }
                  }
                  if(!_loc15_ && _loc11_[_loc21_] == param3.x && _loc11_[_loc22_] == param3.y && _loc11_[_loc23_] == param3.z)
                  {
                     this._normalTmp.x = _loc10_[_loc21_];
                     this._normalTmp.y = _loc10_[_loc22_];
                     this._normalTmp.z = _loc10_[_loc23_];
                     _loc26_ = Vector3D.angleBetween(this._normalTmp,this._normal2);
                     if(_loc26_ < this.MAXRAD)
                     {
                        this._normal2.x = (this._normalTmp.x + this._normal2.x) * 0.5;
                        this._normal2.y = (this._normalTmp.y + this._normal2.y) * 0.5;
                        this._normal2.z = (this._normalTmp.z + this._normal2.z) * 0.5;
                        if(_loc9_[_loc19_] == param6.u && _loc9_[_loc20_] == param6.v)
                        {
                           _loc15_ = true;
                           _loc18_ = _loc24_;
                        }
                     }
                  }
               }
            }
         }
         if(!_loc13_)
         {
            _loc16_ = _loc11_.length / 3;
            _loc11_.push(param1.x,param1.y,param1.z);
            _loc9_.push(param4.u,param4.v);
            if(this._smoothSurface)
            {
               _loc10_.push(this._normal0.x,this._normal0.y,this._normal0.z);
            }
         }
         if(!_loc14_)
         {
            _loc17_ = _loc11_.length / 3;
            _loc11_.push(param2.x,param2.y,param2.z);
            _loc9_.push(param5.u,param5.v);
            if(this._smoothSurface)
            {
               _loc10_.push(this._normal1.x,this._normal1.y,this._normal1.z);
            }
         }
         if(!_loc15_)
         {
            _loc18_ = _loc11_.length / 3;
            _loc11_.push(param3.x,param3.y,param3.z);
            _loc9_.push(param6.u,param6.v);
            if(this._smoothSurface)
            {
               _loc10_.push(this._normal2.x,this._normal2.y,this._normal2.z);
            }
         }
         _loc12_.push(_loc16_,_loc17_,_loc18_);
      }
      
      private function initHolders() : void
      {
         this._uvarr = new Vector.<UV>();
         this._uva = new UV(0,0);
         this._uvb = new UV(0,0);
         this._uvc = new UV(0,0);
         this._uvd = new UV(0,0);
         this._va = new Vector3D(0,0,0);
         this._vb = new Vector3D(0,0,0);
         this._vc = new Vector3D(0,0,0);
         this._vd = new Vector3D(0,0,0);
         this._uvs = new Vector.<Number>();
         this._vertices = new Vector.<Number>();
         this._indices = new Vector.<uint>();
         this._normals = new Vector.<Number>();
         if(this._smoothSurface)
         {
            this._normal0 = new Vector3D(0,0,0);
            this._normal1 = new Vector3D(0,0,0);
            this._normal2 = new Vector3D(0,0,0);
            this._normalTmp = new Vector3D(0,0,0);
         }
         else
         {
            this._subGeometry.autoDeriveVertexNormals = true;
         }
         this._subGeometry.autoDeriveVertexTangents = true;
         if(Boolean(this._materials) && this._thickness > 0)
         {
            this.initSubGeometryList();
         }
      }
      
      private function buildThicknessPoints(param1:Vector.<Vector3D>, param2:Number, param3:String, param4:String) : Array
      {
         var _loc7_:int = 0;
         var _loc9_:FourPoints = null;
         var _loc10_:FourPoints = null;
         var _loc11_:FourPoints = null;
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         _loc7_ = 0;
         while(_loc7_ < param1.length - 1)
         {
            if(param1[_loc7_][param3] == 0 && param1[_loc7_][param4] == 0)
            {
               param1[_loc7_][param3] = this.EPS;
            }
            if(param1[_loc7_ + 1][param4] != null && param1[_loc7_][param4] == param1[_loc7_ + 1][param4])
            {
               param1[_loc7_ + 1][param4] += this.EPS;
            }
            if(param1[_loc7_][param3] != null && param1[_loc7_][param3] == param1[_loc7_ + 1][param3])
            {
               param1[_loc7_ + 1][param3] += this.EPS;
            }
            _loc5_.push(this.defineAnchors(param1[_loc7_],param1[_loc7_ + 1],param2,param3,param4));
            _loc7_++;
         }
         var _loc8_:int = int(_loc5_.length);
         if(_loc8_ > 1)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               if(_loc7_ < _loc8_)
               {
                  _loc9_ = this.defineLines(_loc7_,_loc5_[_loc7_],_loc5_[_loc7_ + 1],_loc6_);
               }
               else
               {
                  _loc9_ = this.defineLines(_loc7_,_loc5_[_loc7_],_loc5_[_loc7_ - 1],_loc6_);
               }
               if(_loc9_ != null)
               {
                  _loc6_.push(_loc9_);
               }
               _loc7_++;
            }
         }
         else
         {
            _loc10_ = new FourPoints();
            _loc11_ = _loc5_[0];
            _loc10_.pt1 = _loc11_.pt1;
            _loc10_.pt2 = _loc11_.pt2;
            _loc10_.pt3 = _loc11_.pt3;
            _loc10_.pt4 = _loc11_.pt4;
            _loc6_ = [_loc10_];
         }
         return _loc6_;
      }
      
      private function defineLines(param1:int, param2:FourPoints, param3:FourPoints = null, param4:Array = null) : FourPoints
      {
         var _loc5_:FourPoints = null;
         var _loc6_:FourPoints = new FourPoints();
         if(param3 == null)
         {
            _loc5_ = param4[param1 - 1];
            _loc6_.pt1 = _loc5_.pt3;
            _loc6_.pt2 = _loc5_.pt4;
            _loc6_.pt3 = param2.pt3;
            _loc6_.pt4 = param2.pt4;
            return _loc6_;
         }
         var _loc7_:Line = this.buildObjectLine(param2.pt1.x,param2.pt1.y,param2.pt3.x,param2.pt3.y);
         var _loc8_:Line = this.buildObjectLine(param2.pt2.x,param2.pt2.y,param2.pt4.x,param2.pt4.y);
         var _loc9_:Line = this.buildObjectLine(param3.pt1.x,param3.pt1.y,param3.pt3.x,param3.pt3.y);
         var _loc10_:Line = this.buildObjectLine(param3.pt2.x,param3.pt2.y,param3.pt4.x,param3.pt4.y);
         var _loc11_:Point = this.lineIntersect(_loc9_,_loc7_);
         var _loc12_:Point = this.lineIntersect(_loc8_,_loc10_);
         if(_loc11_ != null && _loc12_ != null)
         {
            if(param1 == 0)
            {
               _loc6_.pt1 = param2.pt1;
               _loc6_.pt2 = param2.pt2;
               _loc6_.pt3 = _loc11_;
               _loc6_.pt4 = _loc12_;
               return _loc6_;
            }
            _loc5_ = param4[param1 - 1];
            _loc6_.pt1 = _loc5_.pt3;
            _loc6_.pt2 = _loc5_.pt4;
            _loc6_.pt3 = _loc11_;
            _loc6_.pt4 = _loc12_;
            return _loc6_;
         }
         return null;
      }
      
      private function defineAnchors(param1:Vector3D, param2:Vector3D, param3:Number, param4:String, param5:String) : FourPoints
      {
         var _loc6_:Number = Math.atan2(param1[param5] - param2[param5],param1[param4] - param2[param4]) * 180 / Math.PI;
         _loc6_ = _loc6_ - 270;
         var _loc7_:Number = _loc6_ + 180;
         var _loc8_:FourPoints = new FourPoints();
         _loc8_.pt1 = new Point(param1[param4],param1[param5]);
         _loc8_.pt2 = new Point(param1[param4],param1[param5]);
         _loc8_.pt3 = new Point(param2[param4],param2[param5]);
         _loc8_.pt4 = new Point(param2[param4],param2[param5]);
         var _loc9_:Number = param3 * 0.5;
         _loc8_.pt1.x += Math.cos(-_loc6_ / 180 * Math.PI) * _loc9_;
         _loc8_.pt1.y += Math.sin(_loc6_ / 180 * Math.PI) * _loc9_;
         _loc8_.pt2.x += Math.cos(-_loc7_ / 180 * Math.PI) * _loc9_;
         _loc8_.pt2.y += Math.sin(_loc7_ / 180 * Math.PI) * _loc9_;
         _loc8_.pt3.x += Math.cos(-_loc6_ / 180 * Math.PI) * _loc9_;
         _loc8_.pt3.y += Math.sin(_loc6_ / 180 * Math.PI) * _loc9_;
         _loc8_.pt4.x += Math.cos(-_loc7_ / 180 * Math.PI) * _loc9_;
         _loc8_.pt4.y += Math.sin(_loc7_ / 180 * Math.PI) * _loc9_;
         return _loc8_;
      }
      
      private function buildObjectLine(param1:Number, param2:Number, param3:Number, param4:Number) : Line
      {
         var _loc5_:Line = new Line();
         _loc5_.ax = param1;
         _loc5_.ay = param2;
         _loc5_.bx = param3 - param1;
         _loc5_.by = param4 - param2;
         return _loc5_;
      }
      
      private function lineIntersect(param1:Line, param2:Line) : Point
      {
         param1.bx = param1.bx == 0 ? this.EPS : param1.bx;
         param2.bx = param2.bx == 0 ? this.EPS : param2.bx;
         var _loc3_:Number = param1.by / param1.bx;
         var _loc4_:Number = param1.ay - _loc3_ * param1.ax;
         var _loc5_:Number = param2.by / param2.bx;
         var _loc6_:Number = param2.ay - _loc5_ * param2.ax;
         var _loc7_:Number = _loc3_ - _loc5_ == 0 ? this.EPS : _loc3_ - _loc5_;
         var _loc8_:Number = (_loc6_ - _loc4_) / _loc7_;
         var _loc9_:Number = _loc3_ * _loc8_ + _loc4_;
         if(isFinite(_loc8_) && isFinite(_loc9_))
         {
            return new Point(_loc8_,_loc9_);
         }
         return null;
      }
      
      private function invalidateGeometry() : void
      {
         this._geomDirty = true;
         invalidateBounds();
      }
      
      private function initSubGeometryList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:SubGeometryList = null;
         var _loc3_:SubGeometry = null;
         var _loc4_:String = null;
         if(!this._MaterialsSubGeometries)
         {
            this._MaterialsSubGeometries = new Vector.<SubGeometryList>();
         }
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = new SubGeometryList();
            this._MaterialsSubGeometries.push(_loc2_);
            _loc2_.id = _loc1_;
            if(_loc1_ == 0)
            {
               _loc2_.subGeometry = this._subGeometry;
               _loc2_.uvs = this._uvs;
               _loc2_.vertices = this._vertices;
               _loc2_.indices = this._indices;
               _loc2_.normals = this._normals;
            }
            else
            {
               _loc2_.uvs = new Vector.<Number>();
               _loc2_.vertices = new Vector.<Number>();
               _loc2_.indices = new Vector.<uint>();
               _loc2_.normals = new Vector.<Number>();
            }
            _loc1_++;
         }
         _loc1_ = 1;
         while(_loc1_ < 6)
         {
            switch(_loc1_)
            {
               case 1:
                  _loc4_ = "back";
                  break;
               case 2:
                  _loc4_ = "left";
                  break;
               case 3:
                  _loc4_ = "right";
                  break;
               case 4:
                  _loc4_ = "top";
                  break;
               case 5:
                  _loc4_ = "bottom";
                  break;
               default:
                  _loc4_ = "front";
            }
            if(Boolean(this._materials[_loc4_]) && this._MaterialsSubGeometries[_loc1_].subGeometry == null)
            {
               _loc2_ = this._MaterialsSubGeometries[_loc1_];
               _loc3_ = new SubGeometry();
               _loc2_.material = this._materials[_loc4_];
               _loc2_.subGeometry = _loc3_;
               _loc3_.autoDeriveVertexNormals = true;
               _loc3_.autoDeriveVertexTangents = true;
            }
            _loc1_++;
         }
      }
   }
}

import away3d.core.base.SubGeometry;
import away3d.materials.MaterialBase;
import flash.geom.Point;

class SubGeometryList
{
   
   public var id:uint;
   
   public var uvs:Vector.<Number>;
   
   public var vertices:Vector.<Number>;
   
   public var normals:Vector.<Number>;
   
   public var indices:Vector.<uint>;
   
   public var subGeometry:SubGeometry;
   
   public var material:MaterialBase;
   
   public function SubGeometryList()
   {
      super();
   }
}

class RenderSide
{
   
   public var top:Boolean;
   
   public var bottom:Boolean;
   
   public var right:Boolean;
   
   public var left:Boolean;
   
   public var front:Boolean;
   
   public var back:Boolean;
   
   public function RenderSide()
   {
      super();
   }
}

class Line
{
   
   public var ax:Number;
   
   public var ay:Number;
   
   public var bx:Number;
   
   public var by:Number;
   
   public function Line()
   {
      super();
   }
}

class FourPoints
{
   
   public var pt1:Point;
   
   public var pt2:Point;
   
   public var pt3:Point;
   
   public var pt4:Point;
   
   public function FourPoints()
   {
      super();
   }
}
