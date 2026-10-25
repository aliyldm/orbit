package away3d.loaders.parsers
{
   import away3d.animators.AnimationSetBase;
   import away3d.animators.AnimatorBase;
   import away3d.animators.SkeletonAnimationSet;
   import away3d.animators.SkeletonAnimator;
   import away3d.animators.VertexAnimationSet;
   import away3d.animators.VertexAnimator;
   import away3d.animators.data.JointPose;
   import away3d.animators.data.Skeleton;
   import away3d.animators.data.SkeletonJoint;
   import away3d.animators.data.SkeletonPose;
   import away3d.animators.data.UVAnimationFrame;
   import away3d.animators.nodes.SkeletonClipNode;
   import away3d.animators.nodes.UVClipNode;
   import away3d.animators.nodes.VertexClipNode;
   import away3d.animators.states.VertexClipFrame;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.cameras.lenses.LensBase;
   import away3d.cameras.lenses.OrthographicLens;
   import away3d.cameras.lenses.OrthographicOffCenterLens;
   import away3d.cameras.lenses.PerspectiveLens;
   import away3d.containers.ObjectContainer3D;
   import away3d.core.base.CompactSubGeometry;
   import away3d.core.base.Geometry;
   import away3d.core.base.ISubGeometry;
   import away3d.core.base.SubMesh;
   import away3d.entities.Mesh;
   import away3d.entities.TextureProjector;
   import away3d.library.assets.AssetType;
   import away3d.library.assets.IAsset;
   import away3d.lights.DirectionalLight;
   import away3d.lights.LightBase;
   import away3d.lights.PointLight;
   import away3d.lights.shadowmaps.CascadeShadowMapper;
   import away3d.lights.shadowmaps.CubeMapShadowMapper;
   import away3d.lights.shadowmaps.DirectionalShadowMapper;
   import away3d.lights.shadowmaps.NearDirectionalShadowMapper;
   import away3d.lights.shadowmaps.ShadowMapperBase;
   import away3d.loaders.misc.ResourceDependency;
   import away3d.loaders.parsers.utils.ParserUtil;
   import away3d.materials.ColorMaterial;
   import away3d.materials.ColorMultiPassMaterial;
   import away3d.materials.MaterialBase;
   import away3d.materials.MultiPassMaterialBase;
   import away3d.materials.SinglePassMaterialBase;
   import away3d.materials.TextureMaterial;
   import away3d.materials.TextureMultiPassMaterial;
   import away3d.materials.lightpickers.LightPickerBase;
   import away3d.materials.lightpickers.StaticLightPicker;
   import away3d.materials.methods.AlphaMaskMethod;
   import away3d.materials.methods.AnisotropicSpecularMethod;
   import away3d.materials.methods.CascadeShadowMapMethod;
   import away3d.materials.methods.CelDiffuseMethod;
   import away3d.materials.methods.CelSpecularMethod;
   import away3d.materials.methods.ColorMatrixMethod;
   import away3d.materials.methods.ColorTransformMethod;
   import away3d.materials.methods.DepthDiffuseMethod;
   import away3d.materials.methods.DitheredShadowMapMethod;
   import away3d.materials.methods.EffectMethodBase;
   import away3d.materials.methods.EnvMapAmbientMethod;
   import away3d.materials.methods.EnvMapMethod;
   import away3d.materials.methods.FilteredShadowMapMethod;
   import away3d.materials.methods.FogMethod;
   import away3d.materials.methods.FresnelEnvMapMethod;
   import away3d.materials.methods.FresnelSpecularMethod;
   import away3d.materials.methods.GradientDiffuseMethod;
   import away3d.materials.methods.HardShadowMapMethod;
   import away3d.materials.methods.LightMapDiffuseMethod;
   import away3d.materials.methods.LightMapMethod;
   import away3d.materials.methods.NearShadowMapMethod;
   import away3d.materials.methods.OutlineMethod;
   import away3d.materials.methods.PhongSpecularMethod;
   import away3d.materials.methods.ProjectiveTextureMethod;
   import away3d.materials.methods.RefractionEnvMapMethod;
   import away3d.materials.methods.RimLightMethod;
   import away3d.materials.methods.ShadowMapMethodBase;
   import away3d.materials.methods.SimpleWaterNormalMethod;
   import away3d.materials.methods.SoftShadowMapMethod;
   import away3d.materials.methods.SubsurfaceScatteringDiffuseMethod;
   import away3d.materials.methods.WrapDiffuseMethod;
   import away3d.materials.utils.DefaultMaterialManager;
   import away3d.primitives.CapsuleGeometry;
   import away3d.primitives.ConeGeometry;
   import away3d.primitives.CubeGeometry;
   import away3d.primitives.CylinderGeometry;
   import away3d.primitives.PlaneGeometry;
   import away3d.primitives.SkyBox;
   import away3d.primitives.SphereGeometry;
   import away3d.primitives.TorusGeometry;
   import away3d.textures.ATFCubeTexture;
   import away3d.textures.ATFTexture;
   import away3d.textures.BitmapCubeTexture;
   import away3d.textures.BitmapTexture;
   import away3d.textures.CubeTextureBase;
   import away3d.textures.Texture2DBase;
   import away3d.textures.TextureProxyBase;
   import away3d.tools.utils.GeomUtil;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   use namespace arcane;
   
   public class AWD99Parser extends ParserBase
   {
      
      public static const COMPRESSIONMODE_LZMA:String = "lzma";
      
      public static const UNCOMPRESSED:uint = 0;
      
      public static const DEFLATE:uint = 1;
      
      public static const LZMA:uint = 2;
      
      public static const INT8:uint = 1;
      
      public static const INT16:uint = 2;
      
      public static const INT32:uint = 3;
      
      public static const UINT8:uint = 4;
      
      public static const UINT16:uint = 5;
      
      public static const UINT32:uint = 6;
      
      public static const FLOAT32:uint = 7;
      
      public static const FLOAT64:uint = 8;
      
      public static const BOOL:uint = 21;
      
      public static const COLOR:uint = 22;
      
      public static const BADDR:uint = 23;
      
      public static const AWDSTRING:uint = 31;
      
      public static const AWDBYTEARRAY:uint = 32;
      
      public static const VECTOR2x1:uint = 41;
      
      public static const VECTOR3x1:uint = 42;
      
      public static const VECTOR4x1:uint = 43;
      
      public static const MTX3x2:uint = 44;
      
      public static const MTX3x3:uint = 45;
      
      public static const MTX4x3:uint = 46;
      
      public static const MTX4x4:uint = 47;
      
      private var _debug:Boolean = false;
      
      private var _byteData:ByteArray;
      
      private var _cur_block_id:uint;
      
      private var _blocks:Vector.<AWDBlock>;
      
      private var _newBlockBytes:ByteArray;
      
      private var _version:Array;
      
      private var _compression:uint;
      
      private var _accuracyOnBlocks:Boolean;
      
      private var _accuracyMatrix:Boolean;
      
      private var _accuracyGeo:Boolean;
      
      private var _accuracyProps:Boolean;
      
      private var _matrixNrType:uint;
      
      private var _geoNrType:uint;
      
      private var _propsNrType:uint;
      
      private var _streaming:Boolean;
      
      private var _texture_users:Object;
      
      private var _body:ByteArray;
      
      private var _defaultTexture:BitmapTexture;
      
      private var _defaultCubeTexture:BitmapCubeTexture;
      
      private var _defaultBitmapMaterial:TextureMaterial;
      
      private var _cubeTextures:Array;
      
      private var blendModeDic:Vector.<String>;
      
      private var _depthSizeDic:Vector.<uint>;
      
      public function AWD99Parser()
      {
         super(ParserDataFormat.BINARY);
         this.blendModeDic = new Vector.<String>();
         this.blendModeDic.push(BlendMode.NORMAL);
         this.blendModeDic.push(BlendMode.ADD);
         this.blendModeDic.push(BlendMode.ALPHA);
         this.blendModeDic.push(BlendMode.DARKEN);
         this.blendModeDic.push(BlendMode.DIFFERENCE);
         this.blendModeDic.push(BlendMode.ERASE);
         this.blendModeDic.push(BlendMode.HARDLIGHT);
         this.blendModeDic.push(BlendMode.INVERT);
         this.blendModeDic.push(BlendMode.LAYER);
         this.blendModeDic.push(BlendMode.LIGHTEN);
         this.blendModeDic.push(BlendMode.MULTIPLY);
         this.blendModeDic.push(BlendMode.NORMAL);
         this.blendModeDic.push(BlendMode.OVERLAY);
         this.blendModeDic.push(BlendMode.SCREEN);
         this.blendModeDic.push(BlendMode.SHADER);
         this.blendModeDic.push(BlendMode.OVERLAY);
         this._depthSizeDic = new Vector.<uint>();
         this._depthSizeDic.push(256);
         this._depthSizeDic.push(512);
         this._depthSizeDic.push(2048);
         this._depthSizeDic.push(1024);
      }
      
      public static function supportsType(param1:String) : Boolean
      {
         param1 = param1.toLowerCase();
         return param1 == "awd";
      }
      
      public static function supportsData(param1:*) : Boolean
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc2_:ByteArray = ParserUtil.toByteArray(param1);
         if(Boolean(_loc2_) && _loc2_.length >= 5)
         {
            _loc2_.endian = Endian.LITTLE_ENDIAN;
            _loc2_.position = 3;
            _loc3_ = _loc2_.readUnsignedByte();
            _loc4_ = _loc2_.readUnsignedByte();
            return _loc3_ == 99 && _loc4_ == 1;
         }
         return false;
      }
      
      override arcane function resolveDependency(param1:ResourceDependency) : void
      {
         var _loc2_:Array = null;
         var _loc3_:String = null;
         var _loc4_:TextureProxyBase = null;
         var _loc5_:Texture2DBase = null;
         var _loc6_:AWDBlock = null;
         var _loc7_:TextureMaterial = null;
         var _loc8_:Array = null;
         if(param1.assets.length == 1)
         {
            _loc2_ = param1.id.split("#");
            _loc3_ = _loc2_[0];
            if(_loc2_.length == 1)
            {
               _loc4_ = param1.assets[0] as Texture2DBase;
               if(_loc4_)
               {
                  _loc6_ = this._blocks[parseInt(param1.id)];
                  _loc6_.data = _loc4_;
                  _loc4_.resetAssetPath(_loc6_.name,null,true);
                  _loc6_.name = _loc4_.name;
                  finalizeAsset(_loc4_);
                  if(this._debug)
                  {
                  }
               }
            }
            if(_loc2_.length > 1)
            {
               _loc5_ = param1.assets[0] as BitmapTexture;
               this._cubeTextures[uint(_loc2_[1])] = BitmapTexture(_loc5_).bitmapData;
               this._texture_users[_loc3_].push(1);
               if(this._debug)
               {
               }
               if(this._texture_users[_loc3_].length == this._cubeTextures.length)
               {
                  _loc4_ = new BitmapCubeTexture(this._cubeTextures[0],this._cubeTextures[1],this._cubeTextures[2],this._cubeTextures[3],this._cubeTextures[4],this._cubeTextures[5]);
                  _loc6_ = this._blocks[_loc3_];
                  _loc6_.data = _loc4_;
                  _loc4_.resetAssetPath(_loc6_.name,null,true);
                  _loc6_.name = _loc4_.name;
                  finalizeAsset(_loc4_);
                  if(this._debug)
                  {
                  }
               }
            }
         }
      }
      
      override arcane function resolveDependencyFailure(param1:ResourceDependency) : void
      {
      }
      
      override arcane function resolveDependencyName(param1:ResourceDependency, param2:IAsset) : String
      {
         var _loc5_:AWDBlock = null;
         var _loc3_:String = param2.name;
         if(param2)
         {
            _loc5_ = this._blocks[parseInt(param1.id)];
            param2.resetAssetPath(_loc5_.name,null,true);
         }
         var _loc4_:String = param2.name;
         param2.name = _loc3_;
         return _loc4_;
      }
      
      override protected function startParsing(param1:Number) : void
      {
         super.startParsing(param1);
         this._texture_users = {};
         this._byteData = getByteData();
         this._blocks = new Vector.<AWDBlock>();
         this._blocks[0] = new AWDBlock();
         this._blocks[0].data = null;
         this._version = [];
         this._byteData.endian = Endian.LITTLE_ENDIAN;
         this.parseHeader();
         switch(this._compression)
         {
            case DEFLATE:
               this._body = new ByteArray();
               this._byteData.readBytes(this._body,0,this._byteData.bytesAvailable);
               this._body.uncompress();
               break;
            case LZMA:
               this._body = new ByteArray();
               this._byteData.readBytes(this._body,0,this._byteData.bytesAvailable);
               this._body.uncompress(COMPRESSIONMODE_LZMA);
               break;
            case UNCOMPRESSED:
               this._body = this._byteData;
         }
         this._body.endian = Endian.LITTLE_ENDIAN;
      }
      
      override protected function proceedParsing() : Boolean
      {
         while(this._body.bytesAvailable > 0 && !parsingPaused && hasTime())
         {
            this.parseNextBlock();
         }
         if(this._body.bytesAvailable == 0)
         {
            return PARSING_DONE;
         }
         return MORE_TO_PARSE;
      }
      
      private function parseHeader() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Number = NaN;
         this._byteData.position = 3;
         this._version[0] = this._byteData.readUnsignedByte();
         this._version[1] = this._byteData.readUnsignedByte();
         _loc1_ = this._byteData.readUnsignedShort();
         this._streaming = bitFlags.test(_loc1_,bitFlags.FLAG1);
         if(this._version[0] == 99 && this._version[1] == 1)
         {
            this._accuracyMatrix = bitFlags.test(_loc1_,bitFlags.FLAG2);
            this._accuracyGeo = bitFlags.test(_loc1_,bitFlags.FLAG3);
            this._accuracyProps = bitFlags.test(_loc1_,bitFlags.FLAG4);
         }
         this._geoNrType = FLOAT32;
         if(this._accuracyGeo)
         {
            this._geoNrType = FLOAT64;
         }
         this._matrixNrType = FLOAT32;
         if(this._accuracyMatrix)
         {
            this._matrixNrType = FLOAT64;
         }
         this._propsNrType = FLOAT32;
         if(this._accuracyProps)
         {
            this._propsNrType = FLOAT64;
         }
         this._compression = this._byteData.readUnsignedByte();
         if(this._debug)
         {
         }
         _loc2_ = this._byteData.readUnsignedInt();
         if(!this._streaming && _loc2_ != this._byteData.bytesAvailable)
         {
            dieWithError("AWD2 body length does not match header integrity field");
         }
      }
      
      private function parseNextBlock() : void
      {
         var _loc1_:AWDBlock = null;
         var _loc2_:IAsset = null;
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         this._cur_block_id = this._body.readUnsignedInt();
         _loc4_ = this._body.readUnsignedByte();
         _loc5_ = this._body.readUnsignedByte();
         _loc6_ = this._body.readUnsignedByte();
         _loc7_ = this._body.readUnsignedInt();
         var _loc8_:Boolean = bitFlags.test(_loc6_,bitFlags.FLAG4);
         var _loc9_:Boolean = bitFlags.test(_loc6_,bitFlags.FLAG5);
         if(this._accuracyOnBlocks)
         {
            this._accuracyMatrix = bitFlags.test(_loc6_,bitFlags.FLAG1);
            this._accuracyGeo = bitFlags.test(_loc6_,bitFlags.FLAG2);
            this._accuracyProps = bitFlags.test(_loc6_,bitFlags.FLAG3);
            this._geoNrType = FLOAT32;
            if(this._accuracyGeo)
            {
               this._geoNrType = FLOAT64;
            }
            this._matrixNrType = FLOAT32;
            if(this._accuracyMatrix)
            {
               this._matrixNrType = FLOAT64;
            }
            this._propsNrType = FLOAT32;
            if(this._accuracyProps)
            {
               this._propsNrType = FLOAT64;
            }
         }
         var _loc10_:uint = this._body.position + _loc7_;
         if(_loc7_ > this._body.bytesAvailable)
         {
            dieWithError("AWD2 block length is bigger than the bytes that are available!");
            this._body.position += this._body.bytesAvailable;
            return;
         }
         this._newBlockBytes = new ByteArray();
         this._body.readBytes(this._newBlockBytes,0,_loc7_);
         if(_loc8_)
         {
            if(_loc9_)
            {
               this._newBlockBytes.uncompress(COMPRESSIONMODE_LZMA);
            }
            else
            {
               this._newBlockBytes.uncompress();
            }
         }
         this._newBlockBytes.endian = Endian.LITTLE_ENDIAN;
         this._newBlockBytes.position = 0;
         _loc1_ = new AWDBlock();
         _loc1_.len = this._newBlockBytes.position + _loc7_;
         _loc1_.id = this._cur_block_id;
         var _loc11_:uint = this._newBlockBytes.position + _loc7_;
         if(_loc8_)
         {
            _loc11_ = this._newBlockBytes.position + this._newBlockBytes.length;
            _loc1_.len = _loc11_;
         }
         if(this._debug)
         {
         }
         this._blocks[this._cur_block_id] = _loc1_;
         if(this._version[0] == 99 && this._version[1] == 1)
         {
            switch(_loc5_)
            {
               case 11:
                  this.parsePrimitve(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 31:
                  this.parseSkyBox(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 41:
                  this.parseLight(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 42:
                  this.parseCamera(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 43:
                  this.parseTextureProjector(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 51:
                  this.parseLightPicker(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 81:
                  this.parseMaterial_v1(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 83:
                  this.parseCubeTexture(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 91:
                  this.parseSharedMethodBlock(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 92:
                  this.parseShadowMethodBlock(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 111:
                  this.parseMeshPoseAnimation(this._cur_block_id,true);
                  _loc3_ = true;
                  break;
               case 112:
                  this.parseMeshPoseAnimation(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 113:
                  this.parseAnimationSet(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 122:
                  this.parseAnimator(this._cur_block_id);
                  _loc3_ = true;
                  break;
               case 253:
                  this.parseCommand(this._cur_block_id);
                  _loc3_ = true;
            }
         }
         if(_loc3_ == false)
         {
            switch(_loc5_)
            {
               case 1:
                  this.parseTriangleGeometrieBlock(this._cur_block_id);
                  break;
               case 22:
                  this.parseContainer(this._cur_block_id);
                  break;
               case 23:
                  this.parseMeshInstance(this._cur_block_id);
                  break;
               case 81:
                  this.parseMaterial(this._cur_block_id);
                  break;
               case 82:
                  this.parseTexture(this._cur_block_id);
                  break;
               case 101:
                  this.parseSkeleton(this._cur_block_id);
                  break;
               case 102:
                  this.parseSkeletonPose(this._cur_block_id);
                  break;
               case 103:
                  this.parseSkeletonAnimation(this._cur_block_id);
                  break;
               case 121:
                  this.parseUVAnimation(this._cur_block_id);
                  break;
               case 254:
                  this.parseNameSpace(this._cur_block_id);
                  break;
               case 255:
                  this.parseMetaData(this._cur_block_id);
                  break;
               default:
                  if(this._debug)
                  {
                  }
                  this._newBlockBytes.position += _loc7_;
            }
         }
         var _loc12_:uint = 0;
         if(this._newBlockBytes.position == _loc11_)
         {
            if(this._debug)
            {
               if(_loc1_.errorMessages)
               {
                  while(_loc12_ < _loc1_.errorMessages.length)
                  {
                     _loc12_++;
                  }
               }
            }
            if(this._debug)
            {
            }
         }
         else if(this._debug)
         {
            if(_loc1_.errorMessages)
            {
               while(_loc12_ < _loc1_.errorMessages.length)
               {
                  _loc12_++;
               }
            }
         }
         this._body.position = _loc10_;
         this._newBlockBytes = null;
      }
      
      private function parseTriangleGeometrieBlock(param1:uint) : void
      {
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:Vector.<Number> = null;
         var _loc14_:Vector.<Number> = null;
         var _loc15_:AWDProperties = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Boolean = false;
         var _loc19_:uint = 0;
         var _loc20_:uint = 0;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:uint = 0;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Vector.<Number> = null;
         var _loc28_:Vector.<uint> = null;
         var _loc29_:Vector.<Number> = null;
         var _loc30_:Vector.<Number> = null;
         var _loc31_:Vector.<Number> = null;
         var _loc32_:Vector.<Number> = null;
         var _loc2_:Geometry = new Geometry();
         var _loc3_:String = this.parseVarStr();
         var _loc4_:uint = this._newBlockBytes.readUnsignedShort();
         var _loc5_:AWDProperties = this.parseProperties({
            1:this._geoNrType,
            2:this._geoNrType
         });
         var _loc6_:Number = _loc5_.get(1,1);
         var _loc7_:Number = _loc5_.get(2,1);
         var _loc8_:Vector.<ISubGeometry> = new Vector.<ISubGeometry>();
         var _loc9_:uint = 0;
         while(_loc9_ < _loc4_)
         {
            _loc11_ = this._newBlockBytes.readUnsignedInt();
            _loc12_ = this._newBlockBytes.position + _loc11_;
            _loc15_ = this.parseProperties({
               1:this._geoNrType,
               2:this._geoNrType
            });
            while(this._newBlockBytes.position < _loc12_)
            {
               _loc19_ = 0;
               _loc21_ = this._newBlockBytes.readUnsignedByte();
               _loc20_ = this._newBlockBytes.readUnsignedByte();
               _loc22_ = this._newBlockBytes.readUnsignedInt();
               _loc23_ = this._newBlockBytes.position + _loc22_;
               if(_loc21_ == 1)
               {
                  _loc27_ = new Vector.<Number>();
                  while(this._newBlockBytes.position < _loc23_)
                  {
                     _loc24_ = this.readNumber(this._accuracyGeo);
                     _loc25_ = this.readNumber(this._accuracyGeo);
                     _loc26_ = this.readNumber(this._accuracyGeo);
                     var _loc33_:uint;
                     _loc27_[_loc33_ = _loc19_++] = _loc24_;
                     var _loc34_:uint;
                     _loc27_[_loc34_ = _loc19_++] = _loc25_;
                     var _loc35_:uint;
                     _loc27_[_loc35_ = _loc19_++] = _loc26_;
                  }
               }
               else if(_loc21_ == 2)
               {
                  _loc28_ = new Vector.<uint>();
                  while(this._newBlockBytes.position < _loc23_)
                  {
                     _loc28_[_loc33_ = _loc19_++] = this._newBlockBytes.readUnsignedShort();
                  }
               }
               else if(_loc21_ == 3)
               {
                  _loc29_ = new Vector.<Number>();
                  while(this._newBlockBytes.position < _loc23_)
                  {
                     _loc29_[_loc33_ = _loc19_++] = this.readNumber(this._accuracyGeo);
                  }
               }
               else if(_loc21_ == 4)
               {
                  _loc30_ = new Vector.<Number>();
                  while(this._newBlockBytes.position < _loc23_)
                  {
                     _loc30_[_loc33_ = _loc19_++] = this.readNumber(this._accuracyGeo);
                  }
               }
               else if(_loc21_ == 5)
               {
                  _loc31_ = new Vector.<Number>();
                  while(this._newBlockBytes.position < _loc23_)
                  {
                     _loc31_[_loc33_ = _loc19_++] = this.readNumber(this._accuracyGeo);
                  }
               }
               else if(_loc21_ == 6)
               {
                  _loc13_ = new Vector.<Number>();
                  while(this._newBlockBytes.position < _loc23_)
                  {
                     _loc13_[_loc33_ = _loc19_++] = this._newBlockBytes.readUnsignedShort() * 3;
                  }
               }
               else if(_loc21_ == 7)
               {
                  _loc14_ = new Vector.<Number>();
                  while(this._newBlockBytes.position < _loc23_)
                  {
                     _loc14_[_loc33_ = _loc19_++] = this.readNumber(this._accuracyGeo);
                  }
               }
               else if(_loc21_ == 8)
               {
                  _loc32_ = new Vector.<Number>();
                  while(this._newBlockBytes.position < _loc23_)
                  {
                     _loc32_[_loc33_ = _loc19_++] = this.readNumber(this._accuracyGeo);
                  }
               }
               else
               {
                  this._newBlockBytes.position = _loc23_;
               }
            }
            this.parseUserAttributes();
            _loc8_ = GeomUtil.fromVectors(_loc27_,_loc28_,_loc29_,_loc30_,_loc31_,_loc14_,_loc13_,_loc32_);
            _loc16_ = _loc15_.get(1,1);
            _loc17_ = _loc15_.get(2,1);
            _loc18_ = false;
            if(_loc6_ != _loc16_ || _loc7_ != _loc17_)
            {
               _loc18_ = true;
               _loc16_ = _loc6_ / _loc16_;
               _loc17_ = _loc7_ / _loc17_;
            }
            _loc10_ = 0;
            while(_loc10_ < _loc8_.length)
            {
               if(_loc18_)
               {
                  _loc8_[_loc10_].scaleUV(_loc16_,_loc17_);
               }
               _loc2_.addSubGeometry(_loc8_[_loc10_]);
               _loc10_++;
            }
            _loc9_++;
         }
         if(_loc6_ != 1 || _loc7_ != 1)
         {
            _loc2_.scaleUV(_loc6_,_loc7_);
         }
         this.parseUserAttributes();
         finalizeAsset(_loc2_,_loc3_);
         this._blocks[param1].data = _loc2_;
         if(this._debug)
         {
         }
      }
      
      private function parsePrimitve(param1:uint) : void
      {
         var _loc2_:String = null;
         var _loc3_:Geometry = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:AWDProperties = null;
         var _loc7_:Matrix3D = null;
         _loc2_ = this.parseVarStr();
         _loc4_ = this._newBlockBytes.readUnsignedByte();
         _loc6_ = this.parseProperties({
            101:this._geoNrType,
            102:this._geoNrType,
            103:this._geoNrType,
            110:this._geoNrType,
            111:this._geoNrType,
            301:UINT16,
            302:UINT16,
            303:UINT16,
            701:BOOL,
            702:BOOL,
            703:BOOL,
            704:BOOL
         });
         var _loc8_:Array = ["Unsupported Type-ID","PlaneGeometry","CubeGeometry","SphereGeometry","CylinderGeometry","ConeGeometry","CapsuleGeometry","TorusGeometry"];
         switch(_loc4_)
         {
            case 1:
               _loc3_ = new PlaneGeometry(_loc6_.get(101,100),_loc6_.get(102,100),_loc6_.get(301,1),_loc6_.get(302,1),_loc6_.get(701,true),_loc6_.get(702,false));
               break;
            case 2:
               _loc3_ = new CubeGeometry(_loc6_.get(101,100),_loc6_.get(102,100),_loc6_.get(103,100),_loc6_.get(301,1),_loc6_.get(302,1),_loc6_.get(303,1),_loc6_.get(701,true));
               break;
            case 3:
               _loc3_ = new SphereGeometry(_loc6_.get(101,50),_loc6_.get(301,16),_loc6_.get(302,12),_loc6_.get(701,true));
               break;
            case 4:
               _loc3_ = new CylinderGeometry(_loc6_.get(101,50),_loc6_.get(102,50),_loc6_.get(103,100),_loc6_.get(301,16),_loc6_.get(302,1),true,true,true);
               if(!_loc6_.get(701,true))
               {
                  CylinderGeometry(_loc3_).topClosed = false;
               }
               if(!_loc6_.get(702,true))
               {
                  CylinderGeometry(_loc3_).bottomClosed = false;
               }
               if(!_loc6_.get(703,true))
               {
                  CylinderGeometry(_loc3_).yUp = false;
               }
               break;
            case 5:
               _loc3_ = new ConeGeometry(_loc6_.get(101,50),_loc6_.get(102,100),_loc6_.get(301,16),_loc6_.get(302,1),_loc6_.get(701,true),_loc6_.get(702,true));
               break;
            case 6:
               _loc3_ = new CapsuleGeometry(_loc6_.get(101,50),_loc6_.get(102,100),_loc6_.get(301,16),_loc6_.get(302,15),_loc6_.get(701,true));
               break;
            case 7:
               _loc3_ = new TorusGeometry(_loc6_.get(101,50),_loc6_.get(102,50),_loc6_.get(301,16),_loc6_.get(302,8),_loc6_.get(701,true));
               break;
            default:
               _loc3_ = new Geometry();
         }
         if(_loc6_.get(110,1) != 1 || _loc6_.get(111,1) != 1)
         {
            _loc3_.subGeometries;
            _loc3_.scaleUV(_loc6_.get(110,1),_loc6_.get(111,1));
         }
         this.parseUserAttributes();
         _loc3_.name = _loc2_;
         finalizeAsset(_loc3_,_loc2_);
         this._blocks[param1].data = _loc3_;
         if(this._debug)
         {
            if(_loc4_ < 0 || _loc4_ > 7)
            {
               _loc4_ = 0;
            }
         }
      }
      
      private function parseContainer(param1:uint) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:Matrix3D = null;
         var _loc5_:ObjectContainer3D = null;
         var _loc6_:ObjectContainer3D = null;
         var _loc9_:Object = null;
         _loc3_ = this._newBlockBytes.readUnsignedInt();
         _loc4_ = this.parseMatrix3D();
         _loc2_ = this.parseVarStr();
         var _loc7_:String = "Root (TopLevel)";
         _loc5_ = new ObjectContainer3D();
         _loc5_.transform = _loc4_;
         var _loc8_:Array = this.getAssetByID(_loc3_,[AssetType.CONTAINER,AssetType.LIGHT,AssetType.MESH,AssetType.ENTITY,AssetType.SEGMENT_SET]);
         if(_loc8_[0])
         {
            ObjectContainer3D(_loc8_[1]).addChild(_loc5_);
            _loc7_ = ObjectContainer3D(_loc8_[1]).name;
         }
         else if(_loc3_ > 0)
         {
            this._blocks[param1].addError("Could not find a parent for this ObjectContainer3D");
         }
         if(this._version[0] == 99 && this._version[1] == 1)
         {
            _loc9_ = this.parseProperties({
               1:this._matrixNrType,
               2:this._matrixNrType,
               3:this._matrixNrType,
               4:UINT8
            });
            _loc5_.pivotPoint = new Vector3D(_loc9_.get(1,0),_loc9_.get(2,0),_loc9_.get(3,0));
         }
         else
         {
            this.parseProperties(null);
         }
         _loc5_.extra = this.parseUserAttributes();
         finalizeAsset(_loc5_,_loc2_);
         this._blocks[param1].data = _loc5_;
         if(this._debug)
         {
         }
      }
      
      private function parseMeshInstance(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:ObjectContainer3D = null;
         var _loc10_:Geometry = null;
         var _loc14_:Array = null;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:Object = null;
         var _loc20_:Array = null;
         var _loc21_:int = 0;
         var _loc22_:SubMesh = null;
         var _loc23_:Matrix = null;
         var _loc5_:uint = this._newBlockBytes.readUnsignedInt();
         var _loc6_:Matrix3D = this.parseMatrix3D();
         var _loc7_:String = this.parseVarStr();
         var _loc8_:String = "Root (TopLevel)";
         var _loc9_:uint = this._newBlockBytes.readUnsignedInt();
         var _loc11_:Array = this.getAssetByID(_loc9_,[AssetType.GEOMETRY]);
         if(_loc11_[0])
         {
            _loc10_ = _loc11_[1] as Geometry;
         }
         else
         {
            this._blocks[param1].addError("Could not find a Geometry for this Mesh. A empty Geometry is created!");
            _loc10_ = new Geometry();
         }
         this._blocks[param1].geoID = _loc9_;
         var _loc12_:Vector.<MaterialBase> = new Vector.<MaterialBase>();
         _loc2_ = this._newBlockBytes.readUnsignedShort();
         var _loc13_:Array = new Array();
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc17_ = this._newBlockBytes.readUnsignedInt();
            _loc14_ = this.getAssetByID(_loc17_,[AssetType.MATERIAL]);
            if(!_loc14_[0] && _loc17_ > 0)
            {
               this._blocks[param1].addError("Could not find Material Nr " + _loc3_ + " (ID = " + _loc17_ + " ) for this Mesh");
            }
            _loc12_.push(_loc14_[1] as MaterialBase);
            _loc13_.push(MaterialBase(_loc14_[1]).name);
            _loc3_++;
         }
         var _loc15_:Mesh = new Mesh(_loc10_,null);
         _loc15_.transform = _loc6_;
         var _loc16_:Array = this.getAssetByID(_loc5_,[AssetType.CONTAINER,AssetType.LIGHT,AssetType.MESH,AssetType.ENTITY,AssetType.SEGMENT_SET]);
         if(_loc16_[0])
         {
            ObjectContainer3D(_loc16_[1]).addChild(_loc15_);
            _loc8_ = ObjectContainer3D(_loc16_[1]).name;
         }
         else if(_loc5_ > 0)
         {
            this._blocks[param1].addError("Could not find a parent for this Mesh");
         }
         if(_loc12_.length >= 1 && _loc15_.subMeshes.length == 1)
         {
            _loc15_.material = _loc12_[0];
         }
         else if(_loc12_.length > 1)
         {
            _loc18_ = 0;
            while(_loc18_ < _loc15_.subMeshes.length)
            {
               _loc15_.subMeshes[_loc18_].material = _loc12_[Math.min(_loc12_.length - 1,_loc18_)];
               _loc18_++;
            }
         }
         if(this._version[0] == 99 && this._version[1] == 1)
         {
            _loc19_ = this.parseProperties({
               1:this._matrixNrType,
               2:this._matrixNrType,
               3:this._matrixNrType,
               4:UINT8,
               5:BOOL,
               6:this._propsNrType,
               7:this._propsNrType
            });
            _loc15_.pivotPoint = new Vector3D(_loc19_.get(1,0),_loc19_.get(2,0),_loc19_.get(3,0));
            _loc15_.castsShadows = _loc19_.get(5,true);
            _loc20_ = _loc19_.get(6,new Array());
            if(_loc20_.length == 0)
            {
               _loc20_ = _loc19_.get(7,new Array());
            }
            if(_loc20_.length > 0)
            {
               _loc21_ = 0;
               for each(_loc22_ in _loc15_.subMeshes)
               {
                  _loc23_ = new Matrix(_loc20_[_loc21_],_loc20_[_loc21_ + 1],_loc20_[_loc21_ + 2],_loc20_[_loc21_ + 3],_loc20_[_loc21_ + 4],_loc20_[_loc21_ + 5]);
                  if(_loc22_.material is TextureMaterial)
                  {
                     TextureMaterial(_loc22_.material).animateUVs = true;
                  }
                  else if(_loc22_.material is TextureMultiPassMaterial)
                  {
                     TextureMultiPassMaterial(_loc22_.material).animateUVs = true;
                  }
                  _loc22_.offsetU = _loc20_[_loc21_ + 4];
                  _loc22_.offsetV = _loc20_[_loc21_ + 5];
                  _loc22_.scaleU = _loc20_[_loc21_];
                  _loc22_.scaleV = _loc20_[_loc21_ + 3];
                  if(_loc21_ < _loc20_.length)
                  {
                     _loc21_ += 6;
                  }
               }
            }
         }
         else
         {
            this.parseProperties(null);
         }
         _loc15_.extra = this.parseUserAttributes();
         finalizeAsset(_loc15_,_loc7_);
         this._blocks[param1].data = _loc15_;
         if(this._debug)
         {
         }
      }
      
      private function parseSkyBox(param1:uint) : void
      {
         var _loc2_:String = this.parseVarStr();
         var _loc3_:uint = this._newBlockBytes.readUnsignedInt();
         var _loc4_:Array = this.getAssetByID(_loc3_,[AssetType.TEXTURE],"CubeTexture");
         if(!_loc4_[0] && _loc3_ != 0)
         {
            this._blocks[param1].addError("Could not find the Cubetexture (ID = " + _loc3_ + " ) for this SkyBox");
         }
         var _loc5_:SkyBox = new SkyBox(_loc4_[1] as BitmapCubeTexture);
         this.parseProperties(null);
         _loc5_.extra = this.parseUserAttributes();
         finalizeAsset(_loc5_,_loc2_);
         this._blocks[param1].data = _loc5_;
         if(this._debug)
         {
         }
      }
      
      private function parseLight(param1:uint) : void
      {
         var _loc2_:LightBase = null;
         var _loc3_:ShadowMapperBase = null;
         var _loc13_:Array = null;
         var _loc4_:uint = this._newBlockBytes.readUnsignedInt();
         var _loc5_:Matrix3D = this.parseMatrix3D();
         var _loc6_:String = this.parseVarStr();
         var _loc7_:uint = this._newBlockBytes.readUnsignedByte();
         var _loc8_:AWDProperties = this.parseProperties({
            1:this._propsNrType,
            2:this._propsNrType,
            3:COLOR,
            4:this._propsNrType,
            5:this._propsNrType,
            6:BOOL,
            7:COLOR,
            8:this._propsNrType,
            9:UINT8,
            10:UINT8,
            11:this._propsNrType,
            12:UINT16,
            21:this._matrixNrType,
            22:this._matrixNrType,
            23:this._matrixNrType
         });
         var _loc9_:uint = _loc8_.get(9,0);
         var _loc10_:String = "Root (TopLevel)";
         var _loc11_:Array = ["Unsupported LightType","PointLight","DirectionalLight"];
         var _loc12_:Array = ["No ShadowMapper","DirectionalShadowMapper","NearDirectionalShadowMapper","CascadeShadowMapper","CubeMapShadowMapper"];
         if(_loc7_ == 1)
         {
            _loc2_ = new PointLight();
            PointLight(_loc2_).radius = _loc8_.get(1,90000);
            PointLight(_loc2_).fallOff = _loc8_.get(2,100000);
            if(_loc9_ > 0)
            {
               if(_loc9_ == 4)
               {
                  _loc3_ = new CubeMapShadowMapper();
               }
            }
            _loc2_.transform = _loc5_;
         }
         if(_loc7_ == 2)
         {
            _loc2_ = new DirectionalLight(_loc8_.get(21,0),_loc8_.get(22,-1),_loc8_.get(23,1));
            if(_loc9_ > 0)
            {
               if(_loc9_ == 1)
               {
                  _loc3_ = new DirectionalShadowMapper();
               }
               if(_loc9_ == 2)
               {
                  _loc3_ = new NearDirectionalShadowMapper(_loc8_.get(11,0.5));
               }
               if(_loc9_ == 3)
               {
                  _loc3_ = new CascadeShadowMapper(_loc8_.get(12,3));
               }
            }
         }
         if(_loc7_ != 2 && _loc7_ != 1)
         {
            this._blocks[param1].addError("Unsuported lighttype = " + _loc7_);
            return;
         }
         _loc2_.color = _loc8_.get(3,16777215);
         _loc2_.specular = _loc8_.get(4,1);
         _loc2_.diffuse = _loc8_.get(5,1);
         _loc2_.ambientColor = _loc8_.get(7,16777215);
         _loc2_.ambient = _loc8_.get(8,0);
         if(_loc3_)
         {
            if(_loc3_ is CubeMapShadowMapper)
            {
               if(_loc8_.get(10,1) != 1)
               {
                  _loc3_.depthMapSize = this._depthSizeDic[_loc8_.get(10,1)];
               }
            }
            else if(_loc8_.get(10,2) != 2)
            {
               _loc3_.depthMapSize = this._depthSizeDic[_loc8_.get(10,2)];
            }
            _loc2_.shadowMapper = _loc3_;
            _loc2_.castsShadows = true;
         }
         if(_loc4_ != 0)
         {
            _loc13_ = this.getAssetByID(_loc4_,[AssetType.CONTAINER,AssetType.LIGHT,AssetType.MESH,AssetType.ENTITY,AssetType.SEGMENT_SET]);
            if(_loc13_[0])
            {
               ObjectContainer3D(_loc13_[1]).addChild(_loc2_);
               _loc10_ = ObjectContainer3D(_loc13_[1]).name;
            }
            else
            {
               this._blocks[param1].addError("Could not find a parent for this Light");
            }
         }
         this.parseUserAttributes();
         finalizeAsset(_loc2_,_loc6_);
         this._blocks[param1].data = _loc2_;
         if(this._debug)
         {
         }
      }
      
      private function parseCamera(param1:uint) : void
      {
         var _loc6_:LensBase = null;
         var _loc2_:uint = this._newBlockBytes.readUnsignedInt();
         var _loc3_:Matrix3D = this.parseMatrix3D();
         var _loc4_:String = this.parseVarStr();
         var _loc5_:String = "Root (TopLevel)";
         this._newBlockBytes.readUnsignedByte();
         this._newBlockBytes.readShort();
         var _loc7_:uint = uint(this._newBlockBytes.readShort());
         var _loc8_:AWDProperties = this.parseProperties({
            101:this._propsNrType,
            102:this._propsNrType,
            103:this._propsNrType,
            104:this._propsNrType
         });
         switch(_loc7_)
         {
            case 5001:
               _loc6_ = new PerspectiveLens(_loc8_.get(101,60));
               break;
            case 5002:
               _loc6_ = new OrthographicLens(_loc8_.get(101,500));
               break;
            case 5003:
               _loc6_ = new OrthographicOffCenterLens(_loc8_.get(101,-400),_loc8_.get(102,400),_loc8_.get(103,-300),_loc8_.get(104,300));
               break;
            default:
               return;
         }
         var _loc9_:Camera3D = new Camera3D(_loc6_);
         _loc9_.transform = _loc3_;
         var _loc10_:Array = this.getAssetByID(_loc2_,[AssetType.CONTAINER,AssetType.LIGHT,AssetType.MESH,AssetType.ENTITY,AssetType.SEGMENT_SET]);
         if(_loc10_[0])
         {
            ObjectContainer3D(_loc10_[1]).addChild(_loc9_);
            _loc5_ = ObjectContainer3D(_loc10_[1]).name;
         }
         else if(_loc2_ > 0)
         {
            this._blocks[param1].addError("Could not find a parent for this Camera");
         }
         _loc9_.name = _loc4_;
         _loc8_ = this.parseProperties({
            1:this._matrixNrType,
            2:this._matrixNrType,
            3:this._matrixNrType,
            4:UINT8,
            101:this._propsNrType,
            102:this._propsNrType
         });
         _loc9_.pivotPoint = new Vector3D(_loc8_.get(1,0),_loc8_.get(2,0),_loc8_.get(3,0));
         _loc9_.lens.near = _loc8_.get(101,20);
         _loc9_.lens.far = _loc8_.get(102,3000);
         _loc9_.extra = this.parseUserAttributes();
         finalizeAsset(_loc9_,_loc4_);
         this._blocks[param1].data = _loc9_;
         if(this._debug)
         {
         }
      }
      
      private function parseTextureProjector(param1:uint) : void
      {
         var _loc2_:uint = this._newBlockBytes.readUnsignedInt();
         var _loc3_:Matrix3D = this.parseMatrix3D();
         var _loc4_:String = this.parseVarStr();
         var _loc5_:String = "Root (TopLevel)";
         var _loc6_:uint = this._newBlockBytes.readUnsignedInt();
         var _loc7_:Array = this.getAssetByID(_loc6_,[AssetType.TEXTURE]);
         if(!_loc7_[0] && _loc6_ != 0)
         {
            this._blocks[param1].addError("Could not find the Texture (ID = " + _loc6_ + " ( for this TextureProjector!");
         }
         var _loc8_:TextureProjector = new TextureProjector(_loc7_[1]);
         _loc8_.name = _loc4_;
         _loc8_.aspectRatio = this._newBlockBytes.readFloat();
         _loc8_.fieldOfView = this._newBlockBytes.readFloat();
         _loc8_.transform = _loc3_;
         var _loc9_:AWDProperties = this.parseProperties({
            1:this._matrixNrType,
            2:this._matrixNrType,
            3:this._matrixNrType,
            4:UINT8
         });
         _loc8_.pivotPoint = new Vector3D(_loc9_.get(1,0),_loc9_.get(2,0),_loc9_.get(3,0));
         _loc8_.extra = this.parseUserAttributes();
         finalizeAsset(_loc8_,_loc4_);
         this._blocks[param1].data = _loc8_;
         if(this._debug)
         {
         }
      }
      
      private function parseLightPicker(param1:uint) : void
      {
         var _loc7_:Array = null;
         var _loc2_:String = this.parseVarStr();
         var _loc3_:uint = this._newBlockBytes.readUnsignedShort();
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:Array = new Array();
         _loc5_ = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = int(this._newBlockBytes.readUnsignedInt());
            _loc7_ = this.getAssetByID(_loc6_,[AssetType.LIGHT]);
            if(_loc7_[0])
            {
               _loc4_.push(_loc7_[1] as LightBase);
               _loc8_.push(LightBase(_loc7_[1]).name);
            }
            else
            {
               this._blocks[param1].addError("Could not find a Light Nr " + _loc5_ + " (ID = " + _loc6_ + " ) for this LightPicker");
            }
            _loc5_++;
         }
         if(_loc4_.length == 0)
         {
            this._blocks[param1].addError("Could not create this LightPicker, cause no Light was found.");
            this.parseUserAttributes();
            return;
         }
         var _loc9_:LightPickerBase = new StaticLightPicker(_loc4_);
         _loc9_.name = _loc2_;
         this.parseUserAttributes();
         finalizeAsset(_loc9_,_loc2_);
         this._blocks[param1].data = _loc9_;
         if(this._debug)
         {
         }
      }
      
      private function parseMaterial(param1:uint) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:AWDProperties = null;
         var _loc5_:MaterialBase = null;
         var _loc6_:Object = null;
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:Array = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         _loc2_ = this.parseVarStr();
         _loc3_ = this._newBlockBytes.readUnsignedByte();
         _loc8_ = this._newBlockBytes.readUnsignedByte();
         _loc4_ = this.parseProperties({
            1:INT32,
            2:BADDR,
            10:this._propsNrType,
            11:BOOL,
            12:this._propsNrType,
            13:BOOL
         });
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc12_ = this._newBlockBytes.readUnsignedShort();
            this.parseProperties(null);
            this.parseUserAttributes();
            _loc9_ += 1;
         }
         var _loc11_:String = "";
         _loc6_ = this.parseUserAttributes();
         if(_loc3_ == 1)
         {
            _loc11_ += "Parsed a ColorMaterial(SinglePass): Name = \'" + _loc2_ + "\' | ";
            _loc13_ = _loc4_.get(1,13421772);
            if(materialMode < 2)
            {
               _loc5_ = new ColorMaterial(_loc13_,_loc4_.get(10,1));
            }
            else
            {
               _loc5_ = new ColorMultiPassMaterial(_loc13_);
            }
         }
         else if(_loc3_ == 2)
         {
            _loc14_ = _loc4_.get(2,0);
            _loc10_ = this.getAssetByID(_loc14_,[AssetType.TEXTURE]);
            if(!_loc10_[0] && _loc14_ > 0)
            {
               this._blocks[param1].addError("Could not find the DiffsueTexture (ID = " + _loc14_ + " ) for this Material");
            }
            if(materialMode < 2)
            {
               _loc5_ = new TextureMaterial(_loc10_[1]);
               TextureMaterial(_loc5_).alphaBlending = _loc4_.get(11,false);
               TextureMaterial(_loc5_).alpha = _loc4_.get(10,1);
               _loc11_ += "Parsed a TextureMaterial(SinglePass): Name = \'" + _loc2_ + "\' | Texture-Name = " + _loc5_.name;
            }
            else
            {
               _loc5_ = new TextureMultiPassMaterial(_loc10_[1]);
               _loc11_ += "Parsed a TextureMaterial(MultipAss): Name = \'" + _loc2_ + "\' | Texture-Name = " + _loc5_.name;
            }
         }
         _loc5_.extra = _loc6_;
         if(materialMode < 2)
         {
            SinglePassMaterialBase(_loc5_).alphaThreshold = _loc4_.get(12,0);
         }
         else
         {
            MultiPassMaterialBase(_loc5_).alphaThreshold = _loc4_.get(12,0);
         }
         _loc5_.repeat = _loc4_.get(13,false);
         finalizeAsset(_loc5_,_loc2_);
         this._blocks[param1].data = _loc5_;
         if(this._debug)
         {
         }
      }
      
      private function parseMaterial_v1(param1:uint) : void
      {
         var _loc2_:MaterialBase = null;
         var _loc3_:Texture2DBase = null;
         var _loc4_:Texture2DBase = null;
         var _loc5_:Array = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:Texture2DBase = null;
         var _loc20_:Texture2DBase = null;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc6_:String = this.parseVarStr();
         var _loc7_:uint = this._newBlockBytes.readUnsignedByte();
         var _loc8_:uint = this._newBlockBytes.readUnsignedByte();
         var _loc9_:AWDProperties = this.parseProperties({
            1:UINT32,
            2:BADDR,
            3:BADDR,
            4:UINT8,
            5:BOOL,
            6:BOOL,
            7:BOOL,
            8:BOOL,
            9:UINT8,
            10:this._propsNrType,
            11:BOOL,
            12:this._propsNrType,
            13:BOOL,
            15:this._propsNrType,
            16:UINT32,
            17:BADDR,
            18:this._propsNrType,
            19:this._propsNrType,
            20:UINT32,
            21:BADDR,
            22:BADDR
         });
         var _loc10_:uint = _loc9_.get(4,0);
         var _loc11_:String = "";
         if(_loc10_ >= 2)
         {
            this._blocks[param1].addError("Material-spezialType \'" + _loc10_ + "\' is not supported, can only be 0:singlePass, 1:MultiPass !");
            return;
         }
         if(materialMode == 1)
         {
            _loc10_ = 0;
         }
         else if(materialMode == 2)
         {
            _loc10_ = 1;
         }
         if(_loc10_ < 2)
         {
            if(_loc7_ == 1)
            {
               _loc17_ = _loc17_ = _loc9_.get(1,13421772);
               if(_loc10_ == 1)
               {
                  _loc2_ = new ColorMultiPassMaterial(_loc17_);
                  _loc11_ += "Parsed a ColorMaterial(MultiPass): Name = \'" + _loc6_ + "\' | ";
               }
               else
               {
                  _loc2_ = new ColorMaterial(_loc17_,_loc9_.get(10,1));
                  ColorMaterial(_loc2_).alphaBlending = _loc9_.get(11,false);
                  _loc11_ += "Parsed a ColorMaterial(SinglePass): Name = \'" + _loc6_ + "\' | ";
               }
            }
            else if(_loc7_ == 2)
            {
               _loc18_ = _loc9_.get(2,0);
               _loc5_ = this.getAssetByID(_loc18_,[AssetType.TEXTURE]);
               if(!_loc5_[0] && _loc18_ > 0)
               {
                  this._blocks[param1].addError("Could not find the DiffsueTexture (ID = " + _loc18_ + " ) for this TextureMaterial");
               }
               _loc19_ = _loc5_[1];
               _loc21_ = _loc9_.get(17,0);
               _loc5_ = this.getAssetByID(_loc21_,[AssetType.TEXTURE]);
               if(!_loc5_[0] && _loc21_ != 0)
               {
                  this._blocks[param1].addError("Could not find the AmbientTexture (ID = " + _loc21_ + " ) for this TextureMaterial");
               }
               if(_loc5_[0])
               {
                  _loc20_ = _loc5_[1];
               }
               if(_loc10_ == 1)
               {
                  _loc2_ = new TextureMultiPassMaterial(_loc19_);
                  _loc11_ += "Parsed a TextureMaterial(MultiPass): Name = \'" + _loc6_ + "\' | Texture-Name = " + _loc19_.name;
                  if(_loc20_)
                  {
                     TextureMultiPassMaterial(_loc2_).ambientTexture = _loc20_;
                     _loc11_ += " | AmbientTexture-Name = " + _loc20_.name;
                  }
               }
               else
               {
                  _loc2_ = new TextureMaterial(_loc19_);
                  _loc11_ += "Parsed a TextureMaterial(SinglePass): Name = \'" + _loc6_ + "\' | Texture-Name = " + _loc19_.name;
                  if(_loc20_)
                  {
                     TextureMaterial(_loc2_).ambientTexture = _loc20_;
                     _loc11_ += " | AmbientTexture-Name = " + _loc20_.name;
                  }
                  TextureMaterial(_loc2_).alpha = _loc9_.get(10,1);
                  TextureMaterial(_loc2_).alphaBlending = _loc9_.get(11,false);
               }
            }
            _loc12_ = _loc9_.get(3,0);
            _loc5_ = this.getAssetByID(_loc12_,[AssetType.TEXTURE]);
            if(!_loc5_[0] && _loc12_ != 0)
            {
               this._blocks[param1].addError("Could not find the NormalTexture (ID = " + _loc12_ + " ) for this TextureMaterial");
            }
            if(_loc5_[0])
            {
               _loc3_ = _loc5_[1];
               _loc11_ += " | NormalTexture-Name = " + _loc3_.name;
            }
            _loc13_ = _loc9_.get(21,0);
            _loc5_ = this.getAssetByID(_loc13_,[AssetType.TEXTURE]);
            if(!_loc5_[0] && _loc13_ != 0)
            {
               this._blocks[param1].addError("Could not find the SpecularTexture (ID = " + _loc13_ + " ) for this TextureMaterial");
            }
            if(_loc5_[0])
            {
               _loc4_ = _loc5_[1];
               _loc11_ += " | SpecularTexture-Name = " + _loc4_.name;
            }
            _loc14_ = _loc9_.get(22,0);
            _loc5_ = this.getAssetByID(_loc14_,[AssetType.LIGHT_PICKER]);
            if(!_loc5_[0] && Boolean(_loc14_))
            {
               this._blocks[param1].addError("Could not find the LightPicker (ID = " + _loc14_ + " ) for this TextureMaterial");
            }
            else
            {
               MaterialBase(_loc2_).lightPicker = _loc5_[1] as LightPickerBase;
            }
            MaterialBase(_loc2_).smooth = _loc9_.get(5,true);
            MaterialBase(_loc2_).mipmap = _loc9_.get(6,true);
            MaterialBase(_loc2_).bothSides = _loc9_.get(7,false);
            MaterialBase(_loc2_).alphaPremultiplied = _loc9_.get(8,false);
            MaterialBase(_loc2_).blendMode = this.blendModeDic[_loc9_.get(9,0)];
            MaterialBase(_loc2_).repeat = _loc9_.get(13,false);
            if(_loc10_ == 0)
            {
               if(_loc3_)
               {
                  SinglePassMaterialBase(_loc2_).normalMap = _loc3_;
               }
               if(_loc4_)
               {
                  SinglePassMaterialBase(_loc2_).specularMap = _loc4_;
               }
               SinglePassMaterialBase(_loc2_).alphaThreshold = _loc9_.get(12,0);
               SinglePassMaterialBase(_loc2_).ambient = _loc9_.get(15,1);
               SinglePassMaterialBase(_loc2_).ambientColor = _loc9_.get(16,16777215);
               SinglePassMaterialBase(_loc2_).specular = _loc9_.get(18,1);
               SinglePassMaterialBase(_loc2_).gloss = _loc9_.get(19,50);
               SinglePassMaterialBase(_loc2_).specularColor = _loc9_.get(20,16777215);
            }
            else
            {
               if(_loc3_)
               {
                  MultiPassMaterialBase(_loc2_).normalMap = _loc3_;
               }
               if(_loc4_)
               {
                  MultiPassMaterialBase(_loc2_).specularMap = _loc4_;
               }
               MultiPassMaterialBase(_loc2_).alphaThreshold = _loc9_.get(12,0);
               MultiPassMaterialBase(_loc2_).ambient = _loc9_.get(15,1);
               MultiPassMaterialBase(_loc2_).ambientColor = _loc9_.get(16,16777215);
               MultiPassMaterialBase(_loc2_).specular = _loc9_.get(18,1);
               MultiPassMaterialBase(_loc2_).gloss = _loc9_.get(19,50);
               MultiPassMaterialBase(_loc2_).specularColor = _loc9_.get(20,16777215);
            }
            _loc15_ = 0;
            while(_loc15_ < _loc8_)
            {
               _loc22_ = this._newBlockBytes.readUnsignedShort();
               _loc9_ = this.parseProperties({
                  1:BADDR,
                  2:BADDR,
                  3:BADDR,
                  101:this._propsNrType,
                  102:this._propsNrType,
                  103:this._propsNrType,
                  201:UINT32,
                  202:UINT32,
                  301:UINT16,
                  302:UINT16,
                  401:UINT8,
                  402:UINT8,
                  601:COLOR,
                  602:COLOR,
                  701:BOOL,
                  702:BOOL,
                  801:MTX4x4
               });
               switch(_loc22_)
               {
                  case 999:
                     _loc16_ = _loc9_.get(1,0);
                     _loc5_ = this.getAssetByID(_loc16_,[AssetType.EFFECTS_METHOD]);
                     if(!_loc5_[0])
                     {
                        this._blocks[param1].addError("Could not find the EffectMethod (ID = " + _loc16_ + " ) for this Material");
                     }
                     else
                     {
                        if(_loc10_ == 0)
                        {
                           SinglePassMaterialBase(_loc2_).addMethod(_loc5_[1]);
                        }
                        if(_loc10_ == 1)
                        {
                           MultiPassMaterialBase(_loc2_).addMethod(_loc5_[1]);
                        }
                        _loc11_ += " | EffectMethod-Name = " + EffectMethodBase(_loc5_[1]).name;
                     }
                     break;
                  case 998:
                     _loc16_ = _loc9_.get(1,0);
                     _loc5_ = this.getAssetByID(_loc16_,[AssetType.SHADOW_MAP_METHOD]);
                     if(!_loc5_[0])
                     {
                        this._blocks[param1].addError("Could not find the ShadowMethod (ID = " + _loc16_ + " ) for this Material");
                     }
                     else
                     {
                        if(_loc10_ == 0)
                        {
                           SinglePassMaterialBase(_loc2_).shadowMethod = _loc5_[1];
                        }
                        if(_loc10_ == 1)
                        {
                           MultiPassMaterialBase(_loc2_).shadowMethod = _loc5_[1];
                        }
                        _loc11_ += " | ShadowMethod-Name = " + ShadowMapMethodBase(_loc5_[1]).name;
                     }
                     break;
                  case 1:
                     _loc16_ = _loc9_.get(1,0);
                     _loc5_ = this.getAssetByID(_loc16_,[AssetType.TEXTURE],"CubeTexture");
                     if(!_loc5_[0])
                     {
                        this._blocks[param1].addError("Could not find the EnvMap (ID = " + _loc16_ + " ) for this EnvMapAmbientMethodMaterial");
                     }
                     if(_loc10_ == 0)
                     {
                        SinglePassMaterialBase(_loc2_).ambientMethod = new EnvMapAmbientMethod(_loc5_[1]);
                     }
                     if(_loc10_ == 1)
                     {
                        MultiPassMaterialBase(_loc2_).ambientMethod = new EnvMapAmbientMethod(_loc5_[1]);
                     }
                     _loc11_ += " | EnvMapAmbientMethod | EnvMap-Name =" + CubeTextureBase(_loc5_[1]).name;
                     break;
                  case 51:
                     if(_loc10_ == 0)
                     {
                        SinglePassMaterialBase(_loc2_).diffuseMethod = new DepthDiffuseMethod();
                     }
                     if(_loc10_ == 1)
                     {
                        MultiPassMaterialBase(_loc2_).diffuseMethod = new DepthDiffuseMethod();
                     }
                     _loc11_ += " | DepthDiffuseMethod";
                     break;
                  case 52:
                     _loc16_ = _loc9_.get(1,0);
                     _loc5_ = this.getAssetByID(_loc16_,[AssetType.TEXTURE]);
                     if(!_loc5_[0])
                     {
                        this._blocks[param1].addError("Could not find the GradientDiffuseTexture (ID = " + _loc16_ + " ) for this GradientDiffuseMethod");
                     }
                     if(_loc10_ == 0)
                     {
                        SinglePassMaterialBase(_loc2_).diffuseMethod = new GradientDiffuseMethod(_loc5_[1]);
                     }
                     if(_loc10_ == 1)
                     {
                        MultiPassMaterialBase(_loc2_).diffuseMethod = new GradientDiffuseMethod(_loc5_[1]);
                     }
                     _loc11_ += " | GradientDiffuseMethod | GradientDiffuseTexture-Name =" + Texture2DBase(_loc5_[1]).name;
                     break;
                  case 53:
                     if(_loc10_ == 0)
                     {
                        SinglePassMaterialBase(_loc2_).diffuseMethod = new WrapDiffuseMethod(_loc9_.get(101,5));
                     }
                     if(_loc10_ == 1)
                     {
                        MultiPassMaterialBase(_loc2_).diffuseMethod = new WrapDiffuseMethod(_loc9_.get(101,5));
                     }
                     _loc11_ += " | WrapDiffuseMethod";
                     break;
                  case 54:
                     _loc16_ = _loc9_.get(1,0);
                     _loc5_ = this.getAssetByID(_loc16_,[AssetType.TEXTURE]);
                     if(!_loc5_[0])
                     {
                        this._blocks[param1].addError("Could not find the LightMap (ID = " + _loc16_ + " ) for this LightMapDiffuseMethod");
                     }
                     if(_loc10_ == 0)
                     {
                        SinglePassMaterialBase(_loc2_).diffuseMethod = new LightMapDiffuseMethod(_loc5_[1],this.blendModeDic[_loc9_.get(401,10)],false,SinglePassMaterialBase(_loc2_).diffuseMethod);
                     }
                     if(_loc10_ == 1)
                     {
                        MultiPassMaterialBase(_loc2_).diffuseMethod = new LightMapDiffuseMethod(_loc5_[1],this.blendModeDic[_loc9_.get(401,10)],false,MultiPassMaterialBase(_loc2_).diffuseMethod);
                     }
                     _loc11_ += " | LightMapDiffuseMethod | LightMapTexture-Name =" + Texture2DBase(_loc5_[1]).name;
                     break;
                  case 55:
                     if(_loc10_ == 0)
                     {
                        SinglePassMaterialBase(_loc2_).diffuseMethod = new CelDiffuseMethod(_loc9_.get(401,3),SinglePassMaterialBase(_loc2_).diffuseMethod);
                        CelDiffuseMethod(SinglePassMaterialBase(_loc2_).diffuseMethod).smoothness = _loc9_.get(101,0.1);
                     }
                     if(_loc10_ == 1)
                     {
                        MultiPassMaterialBase(_loc2_).diffuseMethod = new CelDiffuseMethod(_loc9_.get(401,3),MultiPassMaterialBase(_loc2_).diffuseMethod);
                        CelDiffuseMethod(MultiPassMaterialBase(_loc2_).diffuseMethod).smoothness = _loc9_.get(101,0.1);
                     }
                     _loc11_ += " | CelDiffuseMethod";
                     break;
                  case 56:
                     if(_loc10_ == 0)
                     {
                        SinglePassMaterialBase(_loc2_).diffuseMethod = new SubsurfaceScatteringDiffuseMethod();
                        SubsurfaceScatteringDiffuseMethod(SinglePassMaterialBase(_loc2_).diffuseMethod).scattering = _loc9_.get(101,0.2);
                        SubsurfaceScatteringDiffuseMethod(SinglePassMaterialBase(_loc2_).diffuseMethod).translucency = _loc9_.get(102,1);
                        SubsurfaceScatteringDiffuseMethod(SinglePassMaterialBase(_loc2_).diffuseMethod).scatterColor = _loc9_.get(601,16777215);
                     }
                     if(_loc10_ == 1)
                     {
                        MultiPassMaterialBase(_loc2_).diffuseMethod = new SubsurfaceScatteringDiffuseMethod();
                        SubsurfaceScatteringDiffuseMethod(MultiPassMaterialBase(_loc2_).diffuseMethod).scattering = _loc9_.get(101,0.2);
                        SubsurfaceScatteringDiffuseMethod(MultiPassMaterialBase(_loc2_).diffuseMethod).translucency = _loc9_.get(102,1);
                        SubsurfaceScatteringDiffuseMethod(MultiPassMaterialBase(_loc2_).diffuseMethod).scatterColor = _loc9_.get(601,16777215);
                     }
                     _loc11_ += " | SubSurfaceScatteringMethod";
                     break;
                  case 101:
                     if(_loc10_ == 0)
                     {
                        SinglePassMaterialBase(_loc2_).specularMethod = new AnisotropicSpecularMethod();
                     }
                     if(_loc10_ == 1)
                     {
                        MultiPassMaterialBase(_loc2_).specularMethod = new AnisotropicSpecularMethod();
                     }
                     _loc11_ += " | AnisotropicSpecularMethod";
                     break;
                  case 102:
                     if(_loc10_ == 0)
                     {
                        SinglePassMaterialBase(_loc2_).specularMethod = new PhongSpecularMethod();
                     }
                     if(_loc10_ == 1)
                     {
                        MultiPassMaterialBase(_loc2_).specularMethod = new PhongSpecularMethod();
                     }
                     _loc11_ += " | PhongSpecularMethod";
                     break;
                  case 103:
                     if(_loc10_ == 0)
                     {
                        SinglePassMaterialBase(_loc2_).specularMethod = new CelSpecularMethod(_loc9_.get(101,0.5),SinglePassMaterialBase(_loc2_).specularMethod);
                        CelSpecularMethod(SinglePassMaterialBase(_loc2_).specularMethod).smoothness = _loc9_.get(102,0.1);
                     }
                     if(_loc10_ == 1)
                     {
                        MultiPassMaterialBase(_loc2_).specularMethod = new CelSpecularMethod(_loc9_.get(101,0.5),MultiPassMaterialBase(_loc2_).specularMethod);
                        CelSpecularMethod(MultiPassMaterialBase(_loc2_).specularMethod).smoothness = _loc9_.get(102,0.1);
                     }
                     _loc11_ += " | CellSpecularMethod";
                     break;
                  case 104:
                     if(_loc10_ == 0)
                     {
                        SinglePassMaterialBase(_loc2_).specularMethod = new FresnelSpecularMethod(_loc9_.get(701,true),SinglePassMaterialBase(_loc2_).specularMethod);
                        FresnelSpecularMethod(SinglePassMaterialBase(_loc2_).specularMethod).fresnelPower = _loc9_.get(101,5);
                        FresnelSpecularMethod(SinglePassMaterialBase(_loc2_).specularMethod).normalReflectance = _loc9_.get(102,0.1);
                     }
                     if(_loc10_ == 1)
                     {
                        MultiPassMaterialBase(_loc2_).specularMethod = new FresnelSpecularMethod(_loc9_.get(701,true),MultiPassMaterialBase(_loc2_).specularMethod);
                        FresnelSpecularMethod(MultiPassMaterialBase(_loc2_).specularMethod).fresnelPower = _loc9_.get(101,5);
                        FresnelSpecularMethod(MultiPassMaterialBase(_loc2_).specularMethod).normalReflectance = _loc9_.get(102,0.1);
                     }
                     _loc11_ += " | FresnelSpecularMethod";
                     break;
                  case 152:
                     _loc16_ = _loc9_.get(1,0);
                     _loc5_ = this.getAssetByID(_loc16_,[AssetType.TEXTURE]);
                     if(!_loc5_[0])
                     {
                        this._blocks[param1].addError("Could not find the SecoundNormalMap (ID = " + _loc16_ + " ) for this SimpleWaterNormalMethod");
                     }
                     if(_loc10_ == 0)
                     {
                        if(!SinglePassMaterialBase(_loc2_).normalMap)
                        {
                           this._blocks[param1].addError("Could not find a normal Map on this Material to use with this SimpleWaterNormalMethod");
                           SinglePassMaterialBase(_loc2_).normalMap = _loc5_[1];
                        }
                        SinglePassMaterialBase(_loc2_).normalMethod = new SimpleWaterNormalMethod(SinglePassMaterialBase(_loc2_).normalMap,_loc5_[1]);
                     }
                     if(_loc10_ == 1)
                     {
                        if(!MultiPassMaterialBase(_loc2_).normalMap)
                        {
                           this._blocks[param1].addError("Could not find a normal Map on this Material to use with this SimpleWaterNormalMethod");
                           MultiPassMaterialBase(_loc2_).normalMap = _loc5_[1];
                        }
                        MultiPassMaterialBase(_loc2_).normalMethod = new SimpleWaterNormalMethod(MultiPassMaterialBase(_loc2_).normalMap,_loc5_[1]);
                     }
                     _loc11_ += " | SimpleWaterNormalMethod | Second-NormalTexture-Name = " + Texture2DBase(_loc5_[1]).name;
               }
               this.parseUserAttributes();
               _loc15_ += 1;
            }
         }
         MaterialBase(_loc2_).extra = this.parseUserAttributes();
         finalizeAsset(_loc2_,_loc6_);
         this._blocks[param1].data = _loc2_;
         if(this._debug)
         {
         }
      }
      
      private function parseTexture(param1:uint) : void
      {
         var _loc2_:Texture2DBase = null;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:ByteArray = null;
         var _loc7_:Array = null;
         this._blocks[param1].name = this.parseVarStr();
         var _loc3_:uint = this._newBlockBytes.readUnsignedByte();
         this._texture_users[this._cur_block_id.toString()] = [];
         if(_loc3_ == 0)
         {
            _loc4_ = this._newBlockBytes.readUnsignedInt();
            _loc5_ = this._newBlockBytes.readUTFBytes(_loc4_);
            addDependency(this._cur_block_id.toString(),new URLRequest(_loc5_),false,null,true);
         }
         else
         {
            _loc4_ = this._newBlockBytes.readUnsignedInt();
            _loc6_ = new ByteArray();
            this._newBlockBytes.readBytes(_loc6_,0,_loc4_);
            addDependency(this._cur_block_id.toString(),null,false,_loc6_,true);
         }
         this.parseProperties(null);
         this._blocks[param1].extras = this.parseUserAttributes();
         pauseAndRetrieveDependencies();
         this._blocks[param1].data = _loc2_;
         if(this._debug)
         {
            _loc7_ = ["external","embed"];
         }
      }
      
      private function parseCubeTexture(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:CubeTextureBase = null;
         var _loc4_:int = 0;
         var _loc6_:String = null;
         var _loc7_:ByteArray = null;
         var _loc8_:Array = null;
         this._cubeTextures = new Array();
         this._texture_users[this._cur_block_id.toString()] = [];
         var _loc5_:uint = this._newBlockBytes.readUnsignedByte();
         this._blocks[param1].name = this.parseVarStr();
         _loc4_ = 0;
         while(_loc4_ < 6)
         {
            this._texture_users[this._cur_block_id.toString()] = [];
            this._cubeTextures.push(null);
            if(_loc5_ == 0)
            {
               _loc2_ = this._newBlockBytes.readUnsignedInt();
               _loc6_ = this._newBlockBytes.readUTFBytes(_loc2_);
               addDependency(this._cur_block_id.toString() + "#" + _loc4_,new URLRequest(_loc6_),false,null,true);
            }
            else
            {
               _loc2_ = this._newBlockBytes.readUnsignedInt();
               _loc7_ = new ByteArray();
               this._newBlockBytes.readBytes(_loc7_,0,_loc2_);
               addDependency(this._cur_block_id.toString() + "#" + _loc4_,null,false,_loc7_,true);
            }
            _loc4_++;
         }
         this.parseProperties(null);
         this._blocks[param1].extras = this.parseUserAttributes();
         pauseAndRetrieveDependencies();
         this._blocks[param1].data = _loc3_;
         if(this._debug)
         {
            _loc8_ = ["external","embed"];
         }
      }
      
      private function parseSharedMethodBlock(param1:uint) : void
      {
         var _loc2_:EffectMethodBase = null;
         this._blocks[param1].name = this.parseVarStr();
         _loc2_ = this.parseSharedMethodList(param1);
         this.parseUserAttributes();
         this._blocks[param1].data = _loc2_;
         finalizeAsset(_loc2_,this._blocks[param1].name);
         this._blocks[param1].data = _loc2_;
         if(this._debug)
         {
         }
      }
      
      private function parseSharedMethodList(param1:uint) : EffectMethodBase
      {
         var _loc3_:EffectMethodBase = null;
         var _loc4_:AWDProperties = null;
         var _loc5_:uint = 0;
         var _loc6_:Array = null;
         var _loc7_:uint = 0;
         var _loc8_:ColorTransform = null;
         var _loc2_:uint = this._newBlockBytes.readUnsignedShort();
         _loc4_ = this.parseProperties({
            1:BADDR,
            2:BADDR,
            3:BADDR,
            101:this._propsNrType,
            102:this._propsNrType,
            103:this._propsNrType,
            104:this._propsNrType,
            105:this._propsNrType,
            106:this._propsNrType,
            107:this._propsNrType,
            201:UINT32,
            202:UINT32,
            301:UINT16,
            302:UINT16,
            401:UINT8,
            402:UINT8,
            601:COLOR,
            602:COLOR,
            701:BOOL,
            702:BOOL
         });
         switch(_loc2_)
         {
            case 401:
               _loc3_ = new ColorMatrixMethod(_loc4_.get(101,new Array(0,0,0,1,1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1)));
               break;
            case 402:
               _loc3_ = new ColorTransformMethod();
               _loc7_ = _loc4_.get(601,0);
               _loc8_ = new ColorTransform(_loc4_.get(102,1),_loc4_.get(103,1),_loc4_.get(104,1),_loc4_.get(101,1),_loc7_ >> 16 & 0xFF,_loc7_ >> 8 & 0xFF,_loc7_ & 0xFF,_loc7_ >> 24 & 0xFF);
               ColorTransformMethod(_loc3_).colorTransform = _loc8_;
               break;
            case 403:
               _loc5_ = _loc4_.get(1,0);
               _loc6_ = this.getAssetByID(_loc5_,[AssetType.TEXTURE],"CubeTexture");
               if(!_loc6_[0])
               {
                  this._blocks[param1].addError("Could not find the EnvMap (ID = " + _loc5_ + " ) for this EnvMapMethod");
               }
               _loc3_ = new EnvMapMethod(_loc6_[1],_loc4_.get(101,1));
               _loc5_ = _loc4_.get(2,0);
               if(_loc5_ > 0)
               {
                  _loc6_ = this.getAssetByID(_loc5_,[AssetType.TEXTURE]);
                  if(!_loc6_[0])
                  {
                     this._blocks[param1].addError("Could not find the Mask-texture (ID = " + _loc5_ + " ) for this EnvMapMethod");
                  }
                  EnvMapMethod(_loc3_).mask = _loc6_[1];
               }
               break;
            case 404:
               _loc5_ = _loc4_.get(1,0);
               _loc6_ = this.getAssetByID(_loc5_,[AssetType.TEXTURE]);
               if(!_loc6_[0])
               {
                  this._blocks[param1].addError("Could not find the LightMap (ID = " + _loc5_ + " ) for this LightMapMethod");
               }
               _loc3_ = new LightMapMethod(_loc6_[1],this.blendModeDic[_loc4_.get(401,10)],_loc4_.get(701,false));
               break;
            case 405:
               _loc5_ = _loc4_.get(1,0);
               _loc6_ = this.getAssetByID(_loc5_,[AssetType.TEXTURE_PROJECTOR]);
               if(!_loc6_[0])
               {
                  this._blocks[param1].addError("Could not find the TextureProjector (ID = " + _loc5_ + " ) for this ProjectiveTextureMethod");
               }
               _loc3_ = new ProjectiveTextureMethod(_loc6_[1],this.blendModeDic[_loc4_.get(401,10)]);
               break;
            case 406:
               _loc3_ = new RimLightMethod(_loc4_.get(601,16777215),_loc4_.get(101,0.4),_loc4_.get(102,2));
               break;
            case 407:
               _loc5_ = _loc4_.get(1,0);
               _loc6_ = this.getAssetByID(_loc5_,[AssetType.TEXTURE]);
               if(!_loc6_[0])
               {
                  this._blocks[param1].addError("Could not find the Alpha-texture (ID = " + _loc5_ + " ) for this AlphaMaskMethod");
               }
               _loc3_ = new AlphaMaskMethod(_loc6_[1],_loc4_.get(701,false));
               break;
            case 408:
               _loc5_ = _loc4_.get(1,0);
               _loc6_ = this.getAssetByID(_loc5_,[AssetType.TEXTURE],"CubeTexture");
               if(!_loc6_[0])
               {
                  this._blocks[param1].addError("Could not find the EnvMap (ID = " + _loc5_ + " ) for this RefractionEnvMapMethod");
               }
               _loc3_ = new RefractionEnvMapMethod(_loc6_[1],_loc4_.get(101,0.1),_loc4_.get(102,0.01),_loc4_.get(103,0.01),_loc4_.get(104,0.01));
               RefractionEnvMapMethod(_loc3_).alpha = _loc4_.get(105,1);
               break;
            case 409:
               _loc3_ = new OutlineMethod(_loc4_.get(601,0),_loc4_.get(101,1),_loc4_.get(701,true),_loc4_.get(702,false));
               break;
            case 410:
               _loc5_ = _loc4_.get(1,0);
               _loc6_ = this.getAssetByID(_loc5_,[AssetType.TEXTURE],"CubeTexture");
               if(!_loc6_[0])
               {
                  this._blocks[param1].addError("Could not find the EnvMap (ID = " + _loc5_ + " ) for this FresnelEnvMapMethod");
               }
               _loc3_ = new FresnelEnvMapMethod(_loc6_[1],_loc4_.get(101,1));
               break;
            case 411:
               _loc3_ = new FogMethod(_loc4_.get(101,0),_loc4_.get(102,1000),_loc4_.get(601,8421504));
         }
         this.parseUserAttributes();
         return _loc3_;
      }
      
      private function parseShadowMethodBlock(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:ShadowMapMethodBase = null;
         var _loc5_:uint = 0;
         this._blocks[param1].name = this.parseVarStr();
         _loc5_ = this._newBlockBytes.readUnsignedInt();
         var _loc6_:Array = this.getAssetByID(_loc5_,[AssetType.LIGHT]);
         if(!_loc6_[0])
         {
            this._blocks[param1].addError("Could not find the TargetLight (ID = " + _loc5_ + " ) for this ShadowMethod - ShadowMethod not created");
            return;
         }
         _loc4_ = this.parseShadowMethodList(_loc6_[1] as LightBase,param1);
         if(!_loc4_)
         {
            return;
         }
         this.parseUserAttributes();
         finalizeAsset(_loc4_,this._blocks[param1].name);
         this._blocks[param1].data = _loc4_;
         if(this._debug)
         {
         }
      }
      
      private function parseShadowMethodList(param1:LightBase, param2:uint) : ShadowMapMethodBase
      {
         var _loc4_:ShadowMapMethodBase = null;
         var _loc6_:uint = 0;
         var _loc7_:Array = null;
         var _loc3_:uint = this._newBlockBytes.readUnsignedShort();
         var _loc5_:AWDProperties = this.parseProperties({
            1:BADDR,
            2:BADDR,
            3:BADDR,
            101:this._propsNrType,
            102:this._propsNrType,
            103:this._propsNrType,
            201:UINT32,
            202:UINT32,
            301:UINT16,
            302:UINT16,
            401:UINT8,
            402:UINT8,
            601:COLOR,
            602:COLOR,
            701:BOOL,
            702:BOOL,
            801:MTX4x4
         });
         switch(_loc3_)
         {
            case 1001:
               _loc6_ = _loc5_.get(1,0);
               _loc7_ = this.getAssetByID(_loc6_,[AssetType.SHADOW_MAP_METHOD]);
               if(!_loc7_[0])
               {
                  this._blocks[param2].addError("Could not find the ShadowBaseMethod (ID = " + _loc6_ + " ) for this CascadeShadowMapMethod - ShadowMethod not created");
                  return _loc4_;
               }
               _loc4_ = new CascadeShadowMapMethod(_loc7_[1]);
               break;
            case 1002:
               _loc6_ = _loc5_.get(1,0);
               _loc7_ = this.getAssetByID(_loc6_,[AssetType.SHADOW_MAP_METHOD]);
               if(!_loc7_[0])
               {
                  this._blocks[param2].addError("Could not find the ShadowBaseMethod (ID = " + _loc6_ + " ) for this NearShadowMapMethod - ShadowMethod not created");
                  return _loc4_;
               }
               _loc4_ = new NearShadowMapMethod(_loc7_[1]);
               break;
            case 1101:
               _loc4_ = new FilteredShadowMapMethod(DirectionalLight(param1));
               FilteredShadowMapMethod(_loc4_).alpha = _loc5_.get(101,1);
               FilteredShadowMapMethod(_loc4_).epsilon = _loc5_.get(102,0.002);
               break;
            case 1102:
               _loc4_ = new DitheredShadowMapMethod(DirectionalLight(param1),_loc5_.get(201,5));
               DitheredShadowMapMethod(_loc4_).alpha = _loc5_.get(101,1);
               DitheredShadowMapMethod(_loc4_).epsilon = _loc5_.get(102,0.002);
               DitheredShadowMapMethod(_loc4_).range = _loc5_.get(103,1);
               break;
            case 1103:
               _loc4_ = new SoftShadowMapMethod(DirectionalLight(param1),_loc5_.get(201,5));
               SoftShadowMapMethod(_loc4_).alpha = _loc5_.get(101,1);
               SoftShadowMapMethod(_loc4_).epsilon = _loc5_.get(102,0.002);
               SoftShadowMapMethod(_loc4_).range = _loc5_.get(103,1);
               break;
            case 1104:
               _loc4_ = new HardShadowMapMethod(param1);
               HardShadowMapMethod(_loc4_).alpha = _loc5_.get(101,1);
               HardShadowMapMethod(_loc4_).epsilon = _loc5_.get(102,0.002);
         }
         this.parseUserAttributes();
         return _loc4_;
      }
      
      private function parseSkeleton(param1:uint) : void
      {
         var _loc6_:SkeletonJoint = null;
         var _loc7_:Matrix3D = null;
         var _loc2_:String = this.parseVarStr();
         var _loc3_:uint = this._newBlockBytes.readUnsignedShort();
         var _loc4_:Skeleton = new Skeleton();
         this.parseProperties(null);
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            this._newBlockBytes.readUnsignedShort();
            _loc6_ = new SkeletonJoint();
            _loc6_.parentIndex = this._newBlockBytes.readUnsignedShort() - 1;
            _loc6_.name = this.parseVarStr();
            _loc7_ = this.parseMatrix3D();
            _loc6_.inverseBindPose = _loc7_.rawData;
            this.parseProperties(null);
            this.parseUserAttributes();
            _loc4_.joints.push(_loc6_);
            _loc5_++;
         }
         this.parseUserAttributes();
         finalizeAsset(_loc4_,_loc2_);
         this._blocks[param1].data = _loc4_;
         if(this._debug)
         {
         }
      }
      
      private function parseSkeletonPose(param1:uint) : void
      {
         var _loc6_:JointPose = null;
         var _loc7_:uint = 0;
         var _loc8_:Vector.<Number> = null;
         var _loc9_:Matrix3D = null;
         var _loc2_:String = this.parseVarStr();
         var _loc3_:uint = this._newBlockBytes.readUnsignedShort();
         this.parseProperties(null);
         var _loc4_:SkeletonPose = new SkeletonPose();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = new JointPose();
            _loc7_ = this._newBlockBytes.readUnsignedByte();
            if(_loc7_ == 1)
            {
               _loc8_ = this.parseMatrix43RawData();
               _loc9_ = new Matrix3D(_loc8_);
               _loc6_.orientation.fromMatrix(_loc9_);
               _loc6_.translation.copyFrom(_loc9_.position);
               _loc4_.jointPoses[_loc5_] = _loc6_;
            }
            _loc5_++;
         }
         this.parseUserAttributes();
         finalizeAsset(_loc4_,_loc2_);
         this._blocks[param1].data = _loc4_;
         if(this._debug)
         {
         }
      }
      
      private function parseSkeletonAnimation(param1:uint) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:uint = 0;
         var _loc8_:Array = null;
         var _loc4_:String = this.parseVarStr();
         var _loc5_:SkeletonClipNode = new SkeletonClipNode();
         var _loc6_:uint = this._newBlockBytes.readUnsignedShort();
         this.parseProperties(null);
         var _loc7_:uint = 0;
         while(_loc7_ < _loc6_)
         {
            _loc3_ = this._newBlockBytes.readUnsignedInt();
            _loc2_ = this._newBlockBytes.readUnsignedShort();
            _loc8_ = this.getAssetByID(_loc3_,[AssetType.SKELETON_POSE]);
            if(!_loc8_[0])
            {
               this._blocks[param1].addError("Could not find the SkeletonPose Frame # " + _loc7_ + " (ID = " + _loc3_ + " ) for this SkeletonClipNode");
            }
            else
            {
               _loc5_.addFrame(this._blocks[_loc3_].data as SkeletonPose,_loc2_);
            }
            _loc7_++;
         }
         if(_loc5_.frames.length == 0)
         {
            this._blocks[param1].addError("Could not this SkeletonClipNode, because no Frames where set.");
            return;
         }
         this.parseUserAttributes();
         finalizeAsset(_loc5_,_loc4_);
         this._blocks[param1].data = _loc5_;
         if(this._debug)
         {
         }
      }
      
      private function parseMeshPoseAnimation(param1:uint, param2:Boolean = false) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Geometry = null;
         var _loc14_:CompactSubGeometry = null;
         var _loc17_:Vector.<uint> = null;
         var _loc18_:Vector.<Number> = null;
         var _loc22_:AWDProperties = null;
         var _loc23_:Geometry = null;
         var _loc3_:uint = 1;
         var _loc15_:* = 0;
         var _loc16_:VertexClipNode = new VertexClipNode();
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Vector.<int> = new Vector.<int>();
         var _loc24_:String = this.parseVarStr();
         var _loc25_:int = int(this._newBlockBytes.readUnsignedInt());
         var _loc26_:Array = this.getAssetByID(_loc25_,[AssetType.GEOMETRY]);
         if(!_loc26_[0])
         {
            this._blocks[param1].addError("Could not find the target-Geometry-Object " + _loc25_ + " ) for this VertexClipNode");
            return;
         }
         var _loc27_:Vector.<Vector.<Number>> = this.getUVForVertexAnimation(_loc25_);
         if(!param2)
         {
            _loc3_ = this._newBlockBytes.readUnsignedShort();
         }
         _loc4_ = this._newBlockBytes.readUnsignedShort();
         _loc19_ = int(this._newBlockBytes.readUnsignedShort());
         _loc20_ = 0;
         while(_loc20_ < _loc19_)
         {
            _loc21_.push(this._newBlockBytes.readUnsignedShort());
            _loc20_++;
         }
         _loc22_ = this.parseProperties({
            1:BOOL,
            2:BOOL
         });
         _loc16_.looping = _loc22_.get(1,true);
         _loc16_.stitchFinalFrame = _loc22_.get(2,false);
         _loc5_ = 0;
         var _loc28_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            _loc7_ = this._newBlockBytes.readUnsignedShort();
            _loc28_ = uint(this._newBlockBytes.readByte());
            _loc13_ = new Geometry();
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               _loc20_ = 0;
               _loc11_ = this._newBlockBytes.readUnsignedInt();
               _loc12_ = this._newBlockBytes.position + _loc11_;
               while(_loc20_ < _loc19_)
               {
                  if(_loc21_[_loc20_] == 1)
                  {
                     _loc17_ = _loc26_[1].subGeometries[_loc6_].indexData;
                     _loc18_ = new Vector.<Number>();
                     _loc15_ = 0;
                     while(this._newBlockBytes.position < _loc12_)
                     {
                        _loc8_ = this.readNumber(this._accuracyGeo);
                        _loc9_ = this.readNumber(this._accuracyGeo);
                        _loc10_ = this.readNumber(this._accuracyGeo);
                        var _loc29_:Number;
                        _loc18_[_loc29_ = _loc15_++] = _loc8_;
                        var _loc30_:Number;
                        _loc18_[_loc30_ = _loc15_++] = _loc9_;
                        var _loc31_:Number;
                        _loc18_[_loc31_ = _loc15_++] = _loc10_;
                     }
                     _loc14_ = new CompactSubGeometry();
                     _loc14_.fromVectors(_loc18_,_loc27_[_loc6_],null,null);
                     _loc14_.updateIndexData(_loc17_);
                     _loc14_.vertexNormalData;
                     _loc14_.vertexTangentData;
                     _loc14_.autoDeriveVertexNormals = false;
                     _loc14_.autoDeriveVertexTangents = false;
                     _loc6_++;
                     _loc13_.addSubGeometry(_loc14_);
                  }
                  else
                  {
                     this._newBlockBytes.position = _loc12_;
                  }
                  _loc20_++;
               }
            }
            _loc16_.addFrame(new VertexClipFrame(_loc13_,_loc7_,_loc28_));
            _loc5_++;
         }
         this.parseUserAttributes();
         finalizeAsset(_loc16_,_loc24_);
         this._blocks[param1].data = _loc16_;
         if(this._debug)
         {
         }
      }
      
      private function parseAnimationSet(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:VertexAnimationSet = null;
         var _loc12_:VertexClipNode = null;
         var _loc13_:SkeletonAnimationSet = null;
         var _loc14_:SkeletonClipNode = null;
         var _loc3_:String = "";
         var _loc4_:String = this.parseVarStr();
         var _loc5_:uint = this._newBlockBytes.readUnsignedShort();
         var _loc6_:AWDProperties = this.parseProperties({1:UINT16});
         var _loc7_:uint = 0;
         var _loc8_:Vector.<SkeletonClipNode> = new Vector.<SkeletonClipNode>();
         var _loc9_:Vector.<VertexClipNode> = new Vector.<VertexClipNode>();
         while(_loc7_ < _loc5_)
         {
            _loc2_ = int(this._newBlockBytes.readUnsignedInt());
            _loc10_ = this.getAssetByID(_loc2_,[AssetType.ANIMATION_NODE]);
            if(!_loc10_[0])
            {
               this._blocks[param1].addError("Could not find the AnimationClipNode Nr " + _loc7_ + " ( " + _loc2_ + " ) for this AnimationSet");
            }
            else
            {
               if(_loc10_[1] is VertexClipNode)
               {
                  _loc9_.push(_loc10_[1]);
               }
               if(_loc10_[1] is SkeletonClipNode)
               {
                  _loc8_.push(_loc10_[1]);
               }
            }
            _loc7_++;
         }
         if(_loc9_.length == 0 && _loc8_.length == 0)
         {
            this._blocks[param1].addError("Could not create this AnimationSet, because it contains no animations");
            return;
         }
         this.parseUserAttributes();
         if(_loc9_.length > 0)
         {
            _loc11_ = new VertexAnimationSet();
            for each(_loc12_ in _loc9_)
            {
               _loc11_.addAnimation(_loc12_);
            }
            finalizeAsset(_loc11_,_loc4_);
            this._blocks[param1].data = _loc11_;
            if(this._debug)
            {
            }
         }
         else if(_loc8_.length > 0)
         {
            _loc10_ = this.getAssetByID(_loc2_,[AssetType.ANIMATION_NODE]);
            _loc13_ = new SkeletonAnimationSet(_loc6_.get(1,4));
            for each(_loc14_ in _loc8_)
            {
               _loc13_.addAnimation(_loc14_);
            }
            finalizeAsset(_loc13_,_loc4_);
            this._blocks[param1].data = _loc13_;
            if(this._debug)
            {
            }
         }
      }
      
      private function parseUVAnimation(param1:uint) : void
      {
         var _loc8_:Matrix = null;
         var _loc9_:uint = 0;
         var _loc10_:UVAnimationFrame = null;
         var _loc2_:String = this.parseVarStr();
         var _loc3_:uint = this._newBlockBytes.readUnsignedShort();
         var _loc4_:AWDProperties = this.parseProperties(null);
         var _loc5_:UVClipNode = new UVClipNode();
         var _loc6_:Sprite = new Sprite();
         var _loc7_:uint = 0;
         while(_loc7_ < _loc3_)
         {
            _loc8_ = this.parseMatrix2D();
            _loc8_.scale(100,100);
            _loc6_.transform.matrix = _loc8_;
            _loc9_ = this._newBlockBytes.readUnsignedShort();
            _loc10_ = new UVAnimationFrame(_loc6_.x * 0.01,_loc6_.y * 0.01,_loc6_.scaleX / 100,_loc6_.scaleY / 100,_loc6_.rotation);
            _loc5_.addFrame(_loc10_,_loc9_);
            _loc7_++;
         }
         this.parseUserAttributes();
         finalizeAsset(_loc5_,_loc2_);
         this._blocks[param1].data = _loc5_;
         if(this._debug)
         {
         }
      }
      
      private function parseAnimator(param1:uint) : void
      {
         var _loc2_:Mesh = null;
         var _loc3_:int = 0;
         var _loc4_:AnimationSetBase = null;
         var _loc14_:Array = null;
         var _loc16_:AnimatorBase = null;
         var _loc5_:String = "";
         var _loc6_:String = this.parseVarStr();
         var _loc7_:uint = this._newBlockBytes.readUnsignedShort();
         var _loc8_:AWDProperties = this.parseProperties({1:BADDR});
         _loc3_ = int(this._newBlockBytes.readUnsignedInt());
         var _loc9_:uint = this._newBlockBytes.readUnsignedShort();
         var _loc10_:Vector.<uint> = new Vector.<uint>();
         var _loc11_:int = 0;
         while(_loc11_ < _loc9_)
         {
            _loc10_.push(this._newBlockBytes.readUnsignedInt());
            _loc11_++;
         }
         var _loc12_:uint = this._newBlockBytes.readUnsignedShort();
         var _loc13_:Boolean = Boolean(this._newBlockBytes.readUnsignedByte());
         this.parseUserAttributes();
         this.parseUserAttributes();
         var _loc15_:Vector.<Mesh> = new Vector.<Mesh>();
         _loc11_ = 0;
         while(_loc11_ < _loc10_.length)
         {
            _loc14_ = this.getAssetByID(_loc10_[_loc11_],[AssetType.MESH]);
            if(_loc14_[0])
            {
               _loc15_.push(_loc14_[1] as Mesh);
            }
            _loc11_++;
         }
         _loc14_ = this.getAssetByID(_loc3_,[AssetType.ANIMATION_SET]);
         if(!_loc14_[0])
         {
            this._blocks[param1].addError("Could not find the AnimationSet ( " + _loc3_ + " ) for this Animator");
            return;
         }
         _loc4_ = _loc14_[1] as AnimationSetBase;
         if(_loc7_ == 1)
         {
            _loc14_ = this.getAssetByID(_loc8_.get(1,0),[AssetType.SKELETON]);
            if(!_loc14_[0])
            {
               this._blocks[param1].addError("Could not find the Skeleton ( " + _loc8_.get(1,0) + " ) for this Animator");
               return;
            }
            _loc16_ = new SkeletonAnimator(_loc4_ as SkeletonAnimationSet,_loc14_[1] as Skeleton);
         }
         else if(_loc7_ == 2)
         {
            _loc16_ = new VertexAnimator(_loc4_ as VertexAnimationSet);
         }
         finalizeAsset(_loc16_,_loc6_);
         this._blocks[param1].data = _loc16_;
         _loc11_ = 0;
         while(_loc11_ < _loc15_.length)
         {
            if(_loc7_ == 1)
            {
               _loc15_[_loc11_].animator = SkeletonAnimator(_loc16_);
            }
            if(_loc7_ == 2)
            {
               _loc15_[_loc11_].animator = VertexAnimator(_loc16_);
            }
            _loc11_++;
         }
         if(this._debug)
         {
         }
      }
      
      private function parseCommand(param1:uint) : void
      {
         var _loc6_:ObjectContainer3D = null;
         var _loc7_:ObjectContainer3D = null;
         var _loc11_:AWDProperties = null;
         var _loc12_:uint = 0;
         var _loc13_:Array = null;
         var _loc2_:Boolean = Boolean(this._newBlockBytes.readUnsignedByte());
         var _loc3_:uint = this._newBlockBytes.readUnsignedInt();
         var _loc4_:Matrix3D = this.parseMatrix3D();
         var _loc5_:String = this.parseVarStr();
         var _loc8_:Array = this.getAssetByID(_loc3_,[AssetType.CONTAINER,AssetType.LIGHT,AssetType.MESH,AssetType.ENTITY,AssetType.SEGMENT_SET]);
         if(_loc8_[0])
         {
            _loc6_ = ObjectContainer3D(_loc8_[1]);
         }
         var _loc9_:uint = uint(this._newBlockBytes.readShort());
         var _loc10_:uint = uint(this._newBlockBytes.readShort());
         _loc11_ = this.parseProperties({1:BADDR});
         switch(_loc10_)
         {
            case 1:
               _loc12_ = _loc11_.get(1,0);
               _loc13_ = this.getAssetByID(_loc12_,[AssetType.LIGHT,AssetType.TEXTURE_PROJECTOR]);
               if(!_loc13_[0] && _loc12_ != 0)
               {
                  this._blocks[param1].addError("Could not find the light (ID = " + _loc12_ + " ( for this CommandBock!");
                  return;
               }
               _loc7_ = _loc13_[1];
               if(_loc6_)
               {
                  _loc6_.addChild(_loc7_);
               }
               _loc7_.transform = _loc4_;
         }
         if(_loc7_)
         {
            _loc11_ = this.parseProperties({
               1:this._matrixNrType,
               2:this._matrixNrType,
               3:this._matrixNrType,
               4:UINT8
            });
            _loc7_.pivotPoint = new Vector3D(_loc11_.get(1,0),_loc11_.get(2,0),_loc11_.get(3,0));
            _loc7_.extra = this.parseUserAttributes();
         }
         this._blocks[param1].data = _loc7_;
         if(this._debug)
         {
         }
      }
      
      private function parseNameSpace(param1:uint) : void
      {
         var _loc2_:uint = this._newBlockBytes.readUnsignedByte();
         var _loc3_:String = this.parseVarStr();
         if(this._debug)
         {
         }
      }
      
      private function parseMetaData(param1:uint) : void
      {
         var _loc2_:AWDProperties = this.parseProperties({
            1:UINT32,
            2:AWDSTRING,
            3:AWDSTRING,
            4:AWDSTRING,
            5:AWDSTRING
         });
         if(this._debug)
         {
         }
      }
      
      private function getUVForVertexAnimation(param1:uint) : Vector.<Vector.<Number>>
      {
         var _loc4_:Vector.<Number> = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<Number> = null;
         if(this._blocks[param1].data is Mesh)
         {
            param1 = this._blocks[param1].geoID;
         }
         if(this._blocks[param1].uvsForVertexAnimation)
         {
            return this._blocks[param1].uvsForVertexAnimation;
         }
         var _loc2_:Geometry = Geometry(this._blocks[[param1]].data);
         var _loc3_:int = 0;
         this._blocks[param1].uvsForVertexAnimation = new Vector.<Vector.<Number>>();
         while(_loc3_ < _loc2_.subGeometries.length)
         {
            _loc9_ = new Vector.<Number>();
            _loc7_ = _loc2_.subGeometries[_loc3_].numVertices;
            _loc4_ = _loc2_.subGeometries[_loc3_].UVData;
            _loc5_ = _loc2_.subGeometries[_loc3_].UVStride;
            _loc6_ = uint(_loc2_.subGeometries[_loc3_].UVOffset);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_.push(_loc4_[_loc6_ + _loc8_ * _loc5_ + 0]);
               _loc9_.push(_loc4_[_loc6_ + _loc8_ * _loc5_ + 1]);
               _loc8_++;
            }
            this._blocks[param1].uvsForVertexAnimation.push(_loc9_);
            _loc3_++;
         }
         return this._blocks[param1].uvsForVertexAnimation;
      }
      
      private function parseVarStr() : String
      {
         var _loc1_:uint = this._newBlockBytes.readUnsignedShort();
         return this._newBlockBytes.readUTFBytes(_loc1_);
      }
      
      private function parseProperties(param1:Object) : AWDProperties
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:AWDProperties = new AWDProperties();
         _loc3_ = this._newBlockBytes.readUnsignedInt();
         _loc2_ = this._newBlockBytes.position + _loc3_;
         if(param1)
         {
            while(this._newBlockBytes.position < _loc2_)
            {
               _loc7_ = this._newBlockBytes.readUnsignedShort();
               _loc6_ = this._newBlockBytes.readUnsignedInt();
               if(this._newBlockBytes.position + _loc6_ > _loc2_)
               {
                  this._newBlockBytes.position = _loc2_;
                  return _loc5_;
               }
               if(param1.hasOwnProperty(_loc7_.toString()))
               {
                  _loc8_ = uint(param1[_loc7_]);
                  _loc5_.set(_loc7_,this.parseAttrValue(_loc8_,_loc6_));
               }
               else
               {
                  this._newBlockBytes.position += _loc6_;
               }
               _loc4_ += 1;
            }
         }
         else
         {
            this._newBlockBytes.position = _loc2_;
         }
         return _loc5_;
      }
      
      private function parseUserAttributes() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:* = undefined;
         _loc2_ = this._newBlockBytes.readUnsignedInt();
         if(_loc2_ > 0)
         {
            _loc1_ = {};
            _loc4_ = this._newBlockBytes.position + _loc2_;
            while(this._newBlockBytes.position < _loc4_)
            {
               _loc5_ = this._newBlockBytes.readUnsignedByte();
               _loc6_ = this.parseVarStr();
               _loc7_ = this._newBlockBytes.readUnsignedByte();
               _loc8_ = this._newBlockBytes.readUnsignedInt();
               if(this._newBlockBytes.position + _loc8_ > _loc4_)
               {
                  this._newBlockBytes.position = _loc4_;
                  return _loc1_;
               }
               switch(_loc7_)
               {
                  case AWDSTRING:
                     _loc9_ = this._newBlockBytes.readUTFBytes(_loc8_);
                     break;
                  case INT8:
                     _loc9_ = this._newBlockBytes.readByte();
                     break;
                  case INT16:
                     _loc9_ = this._newBlockBytes.readShort();
                     break;
                  case INT32:
                     _loc9_ = this._newBlockBytes.readInt();
                     break;
                  case BOOL:
                  case UINT8:
                     _loc9_ = this._newBlockBytes.readUnsignedByte();
                     break;
                  case UINT16:
                     _loc9_ = this._newBlockBytes.readUnsignedShort();
                     break;
                  case UINT32:
                  case BADDR:
                     _loc9_ = this._newBlockBytes.readUnsignedInt();
                     break;
                  case FLOAT32:
                     _loc9_ = this._newBlockBytes.readFloat();
                     break;
                  case FLOAT64:
                     _loc9_ = this._newBlockBytes.readDouble();
                     break;
                  default:
                     _loc9_ = "unimplemented attribute type " + _loc7_;
                     this._newBlockBytes.position += _loc8_;
               }
               if(this._debug)
               {
               }
               _loc1_[_loc6_] = _loc9_;
               _loc3_ += 1;
            }
         }
         return _loc1_;
      }
      
      private function getDefaultMaterial() : IAsset
      {
         if(!this._defaultBitmapMaterial)
         {
            this._defaultBitmapMaterial = DefaultMaterialManager.getDefaultMaterial();
         }
         return this._defaultBitmapMaterial;
      }
      
      private function getDefaultTexture() : IAsset
      {
         if(!this._defaultTexture)
         {
            this._defaultTexture = DefaultMaterialManager.getDefaultTexture();
         }
         return this._defaultTexture;
      }
      
      private function getDefaultCubeTexture() : IAsset
      {
         var _loc1_:BitmapData = null;
         if(!this._defaultCubeTexture)
         {
            if(!this._defaultTexture)
            {
               this._defaultTexture = DefaultMaterialManager.getDefaultTexture();
            }
            _loc1_ = this._defaultTexture.bitmapData;
            this._defaultCubeTexture = new BitmapCubeTexture(_loc1_,_loc1_,_loc1_,_loc1_,_loc1_,_loc1_);
            this._defaultCubeTexture.name = "defaultTexture";
         }
         return this._defaultCubeTexture;
      }
      
      private function getDefaultAsset(param1:String, param2:String) : IAsset
      {
         switch(true)
         {
            case param1 == AssetType.TEXTURE:
               if(param2 == "CubeTexture")
               {
                  return this.getDefaultCubeTexture();
               }
               if(param2 == "SingleTexture")
               {
                  return this.getDefaultTexture();
               }
               break;
            case param1 == AssetType.MATERIAL:
               return this.getDefaultMaterial();
         }
         return null;
      }
      
      private function getAssetByID(param1:uint, param2:Array, param3:String = "SingleTexture") : Array
      {
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         if(param1 > 0)
         {
            if(this._blocks[param1])
            {
               if(this._blocks[param1].data)
               {
                  while(_loc5_ < param2.length)
                  {
                     if(IAsset(this._blocks[param1].data).assetType == param2[_loc5_])
                     {
                        if(param2[_loc5_] == AssetType.TEXTURE && param3 == "CubeTexture")
                        {
                           if(this._blocks[param1].data is BitmapCubeTexture || this._blocks[param1].data is ATFCubeTexture)
                           {
                              _loc4_.push(true);
                              _loc4_.push(this._blocks[param1].data);
                              return _loc4_;
                           }
                        }
                        if(!(param2[_loc5_] == AssetType.TEXTURE && param3 == "SingleTexture"))
                        {
                           _loc4_.push(true);
                           _loc4_.push(this._blocks[param1].data);
                           return _loc4_;
                        }
                        if(this._blocks[param1].data is BitmapTexture || this._blocks[param1].data is ATFTexture)
                        {
                           _loc4_.push(true);
                           _loc4_.push(this._blocks[param1].data);
                           return _loc4_;
                        }
                     }
                     if(param2[_loc5_] == AssetType.GEOMETRY && IAsset(this._blocks[param1].data).assetType == AssetType.MESH)
                     {
                        _loc4_.push(true);
                        _loc4_.push(Mesh(this._blocks[param1].data).geometry);
                        return _loc4_;
                     }
                     _loc5_++;
                  }
               }
            }
         }
         _loc4_.push(false);
         _loc4_.push(this.getDefaultAsset(param2[0],param3));
         return _loc4_;
      }
      
      private function parseAttrValue(param1:uint, param2:uint) : *
      {
         var _loc3_:uint = 0;
         var _loc4_:Function = null;
         var _loc5_:Array = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:* = undefined;
         switch(param1)
         {
            case BOOL:
            case INT8:
               _loc3_ = 1;
               _loc4_ = this._newBlockBytes.readByte;
               break;
            case INT16:
               _loc3_ = 2;
               _loc4_ = this._newBlockBytes.readShort;
               break;
            case INT32:
               _loc3_ = 4;
               _loc4_ = this._newBlockBytes.readInt;
               break;
            case UINT8:
               _loc3_ = 1;
               _loc4_ = this._newBlockBytes.readUnsignedByte;
               break;
            case UINT16:
               _loc3_ = 2;
               _loc4_ = this._newBlockBytes.readUnsignedShort;
               break;
            case UINT32:
            case COLOR:
            case BADDR:
               _loc3_ = 4;
               _loc4_ = this._newBlockBytes.readUnsignedInt;
               break;
            case FLOAT32:
               _loc3_ = 4;
               _loc4_ = this._newBlockBytes.readFloat;
               break;
            case FLOAT64:
               _loc3_ = 8;
               _loc4_ = this._newBlockBytes.readDouble;
               break;
            case AWDSTRING:
               return this._newBlockBytes.readUTFBytes(param2);
            case VECTOR2x1:
            case VECTOR3x1:
            case VECTOR4x1:
            case MTX3x2:
            case MTX3x3:
            case MTX4x3:
            case MTX4x4:
               _loc3_ = 8;
               _loc4_ = this._newBlockBytes.readDouble;
         }
         if(_loc3_ < param2)
         {
            _loc5_ = [];
            _loc6_ = 0;
            _loc7_ = param2 / _loc3_;
            while(_loc6_ < _loc7_)
            {
               _loc5_.push(_loc4_());
               _loc6_++;
            }
            return _loc5_;
         }
         return _loc4_();
      }
      
      private function parseMatrix2D() : Matrix
      {
         var _loc1_:Matrix = null;
         var _loc2_:Vector.<Number> = this.parseMatrix32RawData();
         return new Matrix(_loc2_[0],_loc2_[1],_loc2_[2],_loc2_[3],_loc2_[4],_loc2_[5]);
      }
      
      private function parseMatrix3D() : Matrix3D
      {
         return new Matrix3D(this.parseMatrix43RawData());
      }
      
      private function parseMatrix32RawData() : Vector.<Number>
      {
         var _loc1_:uint = 0;
         var _loc2_:Vector.<Number> = new Vector.<Number>(6,true);
         _loc1_ = 0;
         while(_loc1_ < 6)
         {
            _loc2_[_loc1_] = this._newBlockBytes.readFloat();
            _loc1_++;
         }
         return _loc2_;
      }
      
      private function readNumber(param1:Boolean = false) : Number
      {
         if(param1)
         {
            return this._newBlockBytes.readDouble();
         }
         return this._newBlockBytes.readFloat();
      }
      
      private function parseMatrix43RawData() : Vector.<Number>
      {
         var _loc1_:Vector.<Number> = new Vector.<Number>(16,true);
         _loc1_[0] = this.readNumber(this._accuracyMatrix);
         _loc1_[1] = this.readNumber(this._accuracyMatrix);
         _loc1_[2] = this.readNumber(this._accuracyMatrix);
         _loc1_[3] = 0;
         _loc1_[4] = this.readNumber(this._accuracyMatrix);
         _loc1_[5] = this.readNumber(this._accuracyMatrix);
         _loc1_[6] = this.readNumber(this._accuracyMatrix);
         _loc1_[7] = 0;
         _loc1_[8] = this.readNumber(this._accuracyMatrix);
         _loc1_[9] = this.readNumber(this._accuracyMatrix);
         _loc1_[10] = this.readNumber(this._accuracyMatrix);
         _loc1_[11] = 0;
         _loc1_[12] = this.readNumber(this._accuracyMatrix);
         _loc1_[13] = this.readNumber(this._accuracyMatrix);
         _loc1_[14] = this.readNumber(this._accuracyMatrix);
         _loc1_[15] = 1;
         if(isNaN(_loc1_[0]))
         {
            _loc1_[0] = 1;
            _loc1_[1] = 0;
            _loc1_[2] = 0;
            _loc1_[4] = 0;
            _loc1_[5] = 1;
            _loc1_[6] = 0;
            _loc1_[8] = 0;
            _loc1_[9] = 0;
            _loc1_[10] = 1;
            _loc1_[12] = 0;
            _loc1_[13] = 0;
            _loc1_[14] = 0;
         }
         return _loc1_;
      }
   }
}

import flash.utils.ByteArray;

class AWDBlock
{
   
   public var id:uint;
   
   public var name:String;
   
   public var data:*;
   
   public var len:*;
   
   public var geoID:uint;
   
   public var extras:Object;
   
   public var bytes:ByteArray;
   
   public var errorMessages:Vector.<String>;
   
   public var uvsForVertexAnimation:Vector.<Vector.<Number>>;
   
   public function AWDBlock()
   {
      super();
   }
   
   public function addError(param1:String) : void
   {
      if(!this.errorMessages)
      {
         this.errorMessages = new Vector.<String>();
      }
      this.errorMessages.push(param1);
   }
}

class bitFlags
{
   
   public static const FLAG1:uint = 1;
   
   public static const FLAG2:uint = 2;
   
   public static const FLAG3:uint = 4;
   
   public static const FLAG4:uint = 8;
   
   public static const FLAG5:uint = 16;
   
   public static const FLAG6:uint = 32;
   
   public static const FLAG7:uint = 64;
   
   public static const FLAG8:uint = 128;
   
   public static const FLAG9:uint = 256;
   
   public static const FLAG10:uint = 512;
   
   public static const FLAG11:uint = 1024;
   
   public static const FLAG12:uint = 2048;
   
   public static const FLAG13:uint = 4096;
   
   public static const FLAG14:uint = 8192;
   
   public static const FLAG15:uint = 16384;
   
   public static const FLAG16:uint = 32768;
   
   public function bitFlags()
   {
      super();
   }
   
   public static function test(param1:uint, param2:uint) : Boolean
   {
      return (param1 & param2) == param2;
   }
}

dynamic class AWDProperties
{
   
   public function AWDProperties()
   {
      super();
   }
   
   public function set(param1:uint, param2:*) : void
   {
      this[param1.toString()] = param2;
   }
   
   public function get(param1:uint, param2:*) : *
   {
      if(this.hasOwnProperty(param1.toString()))
      {
         return this[param1.toString()];
      }
      return param2;
   }
}
