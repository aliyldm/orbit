package away3d.loaders.parsers
{
   import away3d.arcane;
   import away3d.containers.ObjectContainer3D;
   import away3d.core.base.CompactSubGeometry;
   import away3d.core.base.Geometry;
   import away3d.entities.Mesh;
   import away3d.loaders.misc.ResourceDependency;
   import away3d.loaders.parsers.utils.ParserUtil;
   import away3d.materials.TextureMaterial;
   import away3d.materials.TextureMultiPassMaterial;
   import away3d.materials.utils.DefaultMaterialManager;
   import away3d.textures.Texture2DBase;
   import flash.geom.Matrix3D;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   use namespace arcane;
   
   public class AWD1Parser extends ParserBase
   {
      
      private const LIMIT:uint = 65535;
      
      private var _textData:String;
      
      private var _startedParsing:Boolean;
      
      private var _objs:Array;
      
      private var _geos:Array;
      
      private var _oList:Array;
      
      private var _aC:Array;
      
      private var _dline:Array;
      
      private var _container:ObjectContainer3D;
      
      private var _meshList:Vector.<Mesh>;
      
      private var _inited:Boolean;
      
      private var _uvs:Array;
      
      private var _charIndex:uint;
      
      private var _oldIndex:uint;
      
      private var _stringLength:uint;
      
      private var _state:String = "";
      
      private var _buffer:uint = 0;
      
      private var _isMesh:Boolean;
      
      private var _isMaterial:Boolean;
      
      private var _id:uint;
      
      public function AWD1Parser()
      {
         super(ParserDataFormat.PLAIN_TEXT);
      }
      
      public static function supportsType(param1:String) : Boolean
      {
         param1 = param1.toLowerCase();
         return param1 == "awd";
      }
      
      public static function supportsData(param1:*) : Boolean
      {
         var _loc2_:ByteArray = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Number = 100;
         _loc2_ = ParserUtil.toByteArray(param1);
         if(_loc2_)
         {
            if(_loc2_.length < 100)
            {
               _loc5_ = _loc2_.length;
            }
            _loc2_.position = 0;
            _loc3_ = _loc2_.readUTFBytes(2);
            _loc4_ = _loc2_.readUTFBytes(_loc5_);
         }
         else
         {
            _loc3_ = param1 is String ? String(param1).substr(0,5) : null;
            _loc4_ = param1 is String ? String(param1).substr(0,_loc5_) : null;
         }
         if(_loc3_ == "//" && _loc4_.indexOf("#v:") != -1)
         {
            return true;
         }
         return false;
      }
      
      override arcane function resolveDependency(param1:ResourceDependency) : void
      {
         if(param1.assets.length != 1)
         {
            return;
         }
         var _loc2_:Texture2DBase = param1.assets[0] as Texture2DBase;
         var _loc3_:Mesh = this.retrieveMeshFromID(param1.id);
         if(Boolean(_loc3_) && Boolean(_loc2_))
         {
            if(materialMode < 2)
            {
               TextureMaterial(_loc3_.material).texture = _loc2_;
            }
            else
            {
               TextureMultiPassMaterial(_loc3_.material).texture = _loc2_;
            }
         }
      }
      
      override arcane function resolveDependencyFailure(param1:ResourceDependency) : void
      {
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:String = null;
         var _loc3_:ObjectContainer3D = null;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         var _loc6_:Matrix3D = null;
         var _loc7_:Object = null;
         var _loc8_:Mesh = null;
         var _loc2_:String = String.fromCharCode(10);
         if(!this._startedParsing)
         {
            this._textData = getTextData();
            this._startedParsing = true;
         }
         if(this._textData.indexOf("#t:bsp") != -1)
         {
            throw new Error("AWD1 holding BSP information is not supported");
         }
         if(this._textData.indexOf(_loc2_) == -1 || this._textData.indexOf(_loc2_) > 200)
         {
            _loc2_ = String.fromCharCode(13);
         }
         if(!this._inited)
         {
            this._inited = true;
            this._meshList = new Vector.<Mesh>();
            this._stringLength = this._textData.length;
            this._charIndex = this._textData.indexOf(_loc2_,0);
            this._oldIndex = this._charIndex;
            this._objs = [];
            this._geos = [];
            this._oList = [];
            this._dline = [];
            this._aC = [];
            this._container = new ObjectContainer3D();
         }
         while(this._charIndex < this._stringLength && hasTime())
         {
            this._charIndex = this._textData.indexOf(_loc2_,this._oldIndex);
            if(this._charIndex == -1)
            {
               this._charIndex = this._stringLength;
            }
            _loc1_ = this._textData.substring(this._oldIndex,this._charIndex);
            if(this._charIndex != this._stringLength)
            {
               this._oldIndex = this._charIndex + 1;
            }
            if(_loc1_.substring(0,1) == "#" && this._state != _loc1_.substring(0,2))
            {
               this._state = _loc1_.substring(0,2);
               this._id = 0;
               this._buffer = 0;
               if(this._state == "#v")
               {
                  _loc1_.substring(3,_loc1_.length - 1);
               }
               if(this._state == "#f")
               {
                  this._isMaterial = (parseInt(_loc1_.substring(3,4)) == 2) as Boolean;
               }
               if(this._state == "#t")
               {
                  this._isMesh = _loc1_.substring(3,7) == "mesh";
               }
            }
            else
            {
               this._dline = _loc1_.split(",");
               if(!(this._dline.length <= 1 && !(this._state == "#m" || this._state == "#d")))
               {
                  if(this._state == "#o")
                  {
                     if(this._buffer == 0)
                     {
                        this._id = this._dline[0];
                        _loc6_ = new Matrix3D(Vector.<Number>([parseFloat(this._dline[1]),parseFloat(this._dline[5]),parseFloat(this._dline[9]),0,parseFloat(this._dline[2]),parseFloat(this._dline[6]),parseFloat(this._dline[10]),0,parseFloat(this._dline[3]),parseFloat(this._dline[7]),parseFloat(this._dline[11]),0,parseFloat(this._dline[4]),parseFloat(this._dline[8]),parseFloat(this._dline[12]),1]));
                        ++this._buffer;
                     }
                     else
                     {
                        _loc5_ = {
                           "name":(this._dline[0] == "" ? "m_" + this._id : this._dline[0]),
                           "transform":_loc6_,
                           "container":parseInt(this._dline[4]),
                           "bothSides":(this._dline[5] == "true" ? true : false),
                           "x":parseFloat(this._dline[9]),
                           "y":parseFloat(this._dline[10]),
                           "z":parseFloat(this._dline[11]),
                           "material":(this._isMaterial && this._dline[12] != null && this._dline[12] != "" ? this._dline[12] : null)
                        };
                        this._objs.push(_loc5_);
                        this._buffer = 0;
                     }
                  }
                  if(this._state == "#d")
                  {
                     switch(this._buffer)
                     {
                        case 0:
                           this._id = this._geos.length;
                           this._geos.push({});
                           ++this._buffer;
                           this._geos[this._id].aVstr = _loc1_.substring(2,_loc1_.length);
                           break;
                        case 1:
                           this._geos[this._id].aUstr = _loc1_.substring(2,_loc1_.length);
                           this._geos[this._id].aV = this.read(this._geos[this._id].aVstr).split(",");
                           this._geos[this._id].aU = this.read(this._geos[this._id].aUstr).split(",");
                           ++this._buffer;
                           break;
                        case 2:
                           this._geos[this._id].f = _loc1_.substring(2,_loc1_.length);
                           this._objs[this._id].geo = this._geos[this._id];
                           this._buffer = 0;
                     }
                  }
                  if(this._state == "#c" && !this._isMesh)
                  {
                     this._id = parseInt(this._dline[0]);
                     _loc3_ = this._aC.length == 0 ? this._container : new ObjectContainer3D();
                     _loc6_ = new Matrix3D(Vector.<Number>([parseFloat(this._dline[1]),parseFloat(this._dline[5]),parseFloat(this._dline[9]),0,parseFloat(this._dline[2]),parseFloat(this._dline[6]),parseFloat(this._dline[10]),0,parseFloat(this._dline[3]),parseFloat(this._dline[7]),parseFloat(this._dline[11]),0,parseFloat(this._dline[4]),parseFloat(this._dline[8]),parseFloat(this._dline[12]),1]));
                     _loc3_.transform = _loc6_;
                     _loc3_.name = this._dline[13] == "null" || this._dline[13] == undefined ? "cont_" + this._id : this._dline[13];
                     this._aC.push(_loc3_);
                     if(_loc3_ != this._container)
                     {
                        this._aC[0].addChild(_loc3_);
                     }
                  }
               }
            }
         }
         if(this._charIndex >= this._stringLength)
         {
            _loc4_ = 0;
            while(_loc4_ < this._objs.length)
            {
               _loc7_ = this._objs[_loc4_];
               if((Boolean(_loc7_)) && Boolean(_loc7_.geo))
               {
                  _loc8_ = new Mesh(new Geometry(),null);
                  _loc8_.name = _loc7_.name;
                  this._meshList.push(_loc8_);
                  if(_loc7_.container != -1 && !this._isMesh)
                  {
                     this._aC[_loc7_.container].addChild(_loc8_);
                  }
                  _loc8_.transform = _loc7_.transform;
                  if(materialMode < 2)
                  {
                     _loc8_.material = new TextureMaterial(DefaultMaterialManager.getDefaultTexture());
                  }
                  else
                  {
                     _loc8_.material = new TextureMultiPassMaterial(DefaultMaterialManager.getDefaultTexture());
                  }
                  _loc8_.material.bothSides = Boolean(_loc7_.bothSides);
                  if(Boolean(_loc7_.material) && _loc7_.material != "")
                  {
                     addDependency(_loc7_.name,new URLRequest(_loc7_.material));
                  }
                  _loc8_.material.name = _loc7_.name;
                  if(Boolean(_loc7_.material) && _loc7_.material != "")
                  {
                     addDependency(_loc7_.name,new URLRequest(_loc7_.material));
                  }
                  this.parseFacesToMesh(_loc7_.geo,_loc8_);
                  finalizeAsset(_loc8_);
               }
               _loc4_++;
            }
            this._objs = this._geos = this._oList = this._aC = this._uvs = null;
            finalizeAsset(this._container);
            return PARSING_DONE;
         }
         return MORE_TO_PARSE;
      }
      
      private function parseFacesToMesh(param1:Object, param2:Mesh) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:CompactSubGeometry = null;
         var _loc8_:Vector.<Number> = new Vector.<Number>();
         var _loc9_:Vector.<uint> = new Vector.<uint>();
         var _loc10_:Vector.<Number> = new Vector.<Number>();
         _loc6_ = param1.f.split(",");
         if(param1.m)
         {
            _loc7_ = param1.m.split(",");
         }
         var _loc15_:Geometry = param2.geometry;
         _loc3_ = 0;
         while(_loc3_ < _loc6_.length)
         {
            if(_loc9_.length + 3 > this.LIMIT)
            {
               _loc14_ = new CompactSubGeometry();
               _loc14_.updateIndexData(_loc9_);
               _loc14_.fromVectors(_loc8_,_loc10_,null,null);
               _loc15_.addSubGeometry(_loc14_);
               _loc8_ = new Vector.<Number>();
               _loc9_ = new Vector.<uint>();
               _loc10_ = new Vector.<Number>();
               _loc12_ = _loc11_ = _loc13_ = 0;
            }
            _loc9_[_loc12_] = _loc12_;
            _loc12_++;
            _loc9_[_loc12_] = _loc12_;
            _loc12_++;
            _loc9_[_loc12_] = _loc12_;
            _loc12_++;
            _loc4_ = param1.aV[parseInt(_loc6_[_loc3_ + 1],16)].split("/");
            var _loc16_:uint;
            _loc8_[_loc16_ = _loc11_++] = parseFloat(_loc4_[0]);
            var _loc17_:uint;
            _loc8_[_loc17_ = _loc11_++] = parseFloat(_loc4_[1]);
            var _loc18_:uint;
            _loc8_[_loc18_ = _loc11_++] = parseFloat(_loc4_[2]);
            _loc4_ = param1.aV[parseInt(_loc6_[_loc3_],16)].split("/");
            var _loc19_:uint;
            _loc8_[_loc19_ = _loc11_++] = parseFloat(_loc4_[0]);
            var _loc20_:uint;
            _loc8_[_loc20_ = _loc11_++] = parseFloat(_loc4_[1]);
            var _loc21_:uint;
            _loc8_[_loc21_ = _loc11_++] = parseFloat(_loc4_[2]);
            _loc4_ = param1.aV[parseInt(_loc6_[_loc3_ + 2],16)].split("/");
            var _loc22_:uint;
            _loc8_[_loc22_ = _loc11_++] = parseFloat(_loc4_[0]);
            var _loc23_:uint;
            _loc8_[_loc23_ = _loc11_++] = parseFloat(_loc4_[1]);
            var _loc24_:uint;
            _loc8_[_loc24_ = _loc11_++] = parseFloat(_loc4_[2]);
            _loc5_ = param1.aU[parseInt(_loc6_[_loc3_ + 4],16)].split("/");
            var _loc25_:uint;
            _loc10_[_loc25_ = _loc13_++] = parseFloat(_loc5_[0]);
            var _loc26_:uint;
            _loc10_[_loc26_ = _loc13_++] = 1 - parseFloat(_loc5_[1]);
            _loc5_ = param1.aU[parseInt(_loc6_[_loc3_ + 3],16)].split("/");
            var _loc27_:uint;
            _loc10_[_loc27_ = _loc13_++] = parseFloat(_loc5_[0]);
            var _loc28_:uint;
            _loc10_[_loc28_ = _loc13_++] = 1 - parseFloat(_loc5_[1]);
            _loc5_ = param1.aU[parseInt(_loc6_[_loc3_ + 5],16)].split("/");
            var _loc29_:uint;
            _loc10_[_loc29_ = _loc13_++] = parseFloat(_loc5_[0]);
            var _loc30_:uint;
            _loc10_[_loc30_ = _loc13_++] = 1 - parseFloat(_loc5_[1]);
            _loc3_ += 6;
         }
         _loc14_ = new CompactSubGeometry();
         _loc14_.updateIndexData(_loc9_);
         _loc14_.fromVectors(_loc8_,_loc10_,null,null);
         _loc15_.addSubGeometry(_loc14_);
      }
      
      private function retrieveMeshFromID(param1:String) : Mesh
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._meshList.length)
         {
            if(Mesh(this._meshList[_loc2_]).name == param1)
            {
               return Mesh(this._meshList[_loc2_]);
            }
            _loc2_++;
         }
         return null;
      }
      
      private function read(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc2_:int = 0;
         var _loc4_:String = "";
         var _loc5_:int = param1.length;
         var _loc6_:* = 0;
         while(_loc6_ < _loc5_)
         {
            if(param1.charCodeAt(_loc6_) >= 44 && param1.charCodeAt(_loc6_) <= 48)
            {
               _loc4_ += param1.substring(_loc6_,_loc6_ + 1);
            }
            else
            {
               _loc2_ = _loc6_;
               _loc3_ = "";
               while(param1.charCodeAt(_loc6_) != 44 && param1.charCodeAt(_loc6_) != 45 && param1.charCodeAt(_loc6_) != 46 && param1.charCodeAt(_loc6_) != 47 && _loc6_ <= _loc5_)
               {
                  _loc6_++;
               }
               _loc3_ = "" + parseInt("0x" + param1.substring(_loc2_,_loc6_),16);
               _loc4_ += _loc3_;
               _loc6_--;
            }
            _loc6_++;
         }
         return _loc4_;
      }
   }
}

