package away3d.loaders.parsers
{
   import away3d.arcane;
   import away3d.core.base.Geometry;
   import away3d.core.base.ISubGeometry;
   import away3d.core.base.data.UV;
   import away3d.core.base.data.Vertex;
   import away3d.entities.Mesh;
   import away3d.library.assets.AssetType;
   import away3d.library.assets.IAsset;
   import away3d.loaders.misc.ResourceDependency;
   import away3d.loaders.parsers.utils.ParserUtil;
   import away3d.materials.ColorMaterial;
   import away3d.materials.ColorMultiPassMaterial;
   import away3d.materials.MaterialBase;
   import away3d.materials.TextureMaterial;
   import away3d.materials.TextureMultiPassMaterial;
   import away3d.materials.methods.BasicSpecularMethod;
   import away3d.materials.utils.DefaultMaterialManager;
   import away3d.textures.Texture2DBase;
   import away3d.tools.utils.GeomUtil;
   import flash.net.URLRequest;
   
   use namespace arcane;
   
   public class OBJParser extends ParserBase
   {
      
      private var _textData:String;
      
      private var _startedParsing:Boolean;
      
      private var _charIndex:uint;
      
      private var _oldIndex:uint;
      
      private var _stringLength:uint;
      
      private var _currentObject:ObjectGroup;
      
      private var _currentGroup:Group;
      
      private var _currentMaterialGroup:MaterialGroup;
      
      private var _objects:Vector.<ObjectGroup>;
      
      private var _materialIDs:Vector.<String>;
      
      private var _materialLoaded:Vector.<LoadedMaterial>;
      
      private var _materialSpecularData:Vector.<SpecularData>;
      
      private var _meshes:Vector.<Mesh>;
      
      private var _lastMtlID:String;
      
      private var _objectIndex:uint;
      
      private var _realIndices:Array;
      
      private var _vertexIndex:uint;
      
      private var _vertices:Vector.<Vertex>;
      
      private var _vertexNormals:Vector.<Vertex>;
      
      private var _uvs:Vector.<UV>;
      
      private var _scale:Number;
      
      private var _mtlLib:Boolean;
      
      private var _mtlLibLoaded:Boolean = true;
      
      private var _activeMaterialID:String = "";
      
      public function OBJParser(param1:Number = 1)
      {
         super(ParserDataFormat.PLAIN_TEXT);
         this._scale = param1;
      }
      
      public static function supportsType(param1:String) : Boolean
      {
         param1 = param1.toLowerCase();
         return param1 == "obj";
      }
      
      public static function supportsData(param1:*) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc2_:String = ParserUtil.toString(param1);
         if(_loc2_)
         {
            _loc3_ = _loc2_.indexOf("\nv ") != -1;
            _loc4_ = _loc2_.indexOf("\nf ") != -1;
         }
         return _loc3_ && _loc4_;
      }
      
      public function set scale(param1:Number) : void
      {
         this._scale = param1;
      }
      
      override arcane function resolveDependency(param1:ResourceDependency) : void
      {
         var _loc2_:String = null;
         var _loc3_:IAsset = null;
         var _loc4_:LoadedMaterial = null;
         if(param1.id == "mtl")
         {
            _loc2_ = ParserUtil.toString(param1.data);
            this.parseMtl(_loc2_);
         }
         else
         {
            if(param1.assets.length != 1)
            {
               return;
            }
            _loc3_ = param1.assets[0];
            if(_loc3_.assetType == AssetType.TEXTURE)
            {
               _loc4_ = new LoadedMaterial();
               _loc4_.materialID = param1.id;
               _loc4_.texture = _loc3_ as Texture2DBase;
               this._materialLoaded.push(_loc4_);
               if(this._meshes.length > 0)
               {
                  this.applyMaterial(_loc4_);
               }
            }
         }
      }
      
      override arcane function resolveDependencyFailure(param1:ResourceDependency) : void
      {
         var _loc2_:LoadedMaterial = null;
         if(param1.id == "mtl")
         {
            this._mtlLib = false;
            this._mtlLibLoaded = false;
         }
         else
         {
            _loc2_ = new LoadedMaterial();
            _loc2_.materialID = param1.id;
            this._materialLoaded.push(_loc2_);
         }
         if(this._meshes.length > 0)
         {
            this.applyMaterial(_loc2_);
         }
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:String = null;
         var _loc3_:Array = null;
         var _loc2_:String = String.fromCharCode(10);
         if(!this._startedParsing)
         {
            this._textData = getTextData();
            this._textData = this._textData.replace(/\\[\r\n]+\s*/gm," ");
         }
         if(this._textData.indexOf(_loc2_) == -1)
         {
            _loc2_ = String.fromCharCode(13);
         }
         if(!this._startedParsing)
         {
            this._startedParsing = true;
            this._vertices = new Vector.<Vertex>();
            this._vertexNormals = new Vector.<Vertex>();
            this._materialIDs = new Vector.<String>();
            this._materialLoaded = new Vector.<LoadedMaterial>();
            this._meshes = new Vector.<Mesh>();
            this._uvs = new Vector.<UV>();
            this._stringLength = this._textData.length;
            this._charIndex = this._textData.indexOf(_loc2_,0);
            this._oldIndex = 0;
            this._objects = new Vector.<ObjectGroup>();
            this._objectIndex = 0;
         }
         while(this._charIndex < this._stringLength && hasTime())
         {
            this._charIndex = this._textData.indexOf(_loc2_,this._oldIndex);
            if(this._charIndex == -1)
            {
               this._charIndex = this._stringLength;
            }
            _loc1_ = this._textData.substring(this._oldIndex,this._charIndex);
            _loc1_ = _loc1_.split("\r").join("");
            _loc1_ = _loc1_.replace("  "," ");
            _loc3_ = _loc1_.split(" ");
            this._oldIndex = this._charIndex + 1;
            this.parseLine(_loc3_);
            if(parsingPaused)
            {
               return MORE_TO_PARSE;
            }
         }
         if(this._charIndex >= this._stringLength)
         {
            if(this._mtlLib && !this._mtlLibLoaded)
            {
               return MORE_TO_PARSE;
            }
            this.translate();
            this.applyMaterials();
            return PARSING_DONE;
         }
         return MORE_TO_PARSE;
      }
      
      private function parseLine(param1:Array) : void
      {
         switch(param1[0])
         {
            case "mtllib":
               this._mtlLib = true;
               this._mtlLibLoaded = false;
               this.loadMtl(param1[1]);
               break;
            case "g":
               this.createGroup(param1);
               break;
            case "o":
               this.createObject(param1);
               break;
            case "usemtl":
               if(this._mtlLib)
               {
                  if(!param1[1])
                  {
                     param1[1] = "def000";
                  }
                  this._materialIDs.push(param1[1]);
                  this._activeMaterialID = param1[1];
                  if(this._currentGroup)
                  {
                     this._currentGroup.materialID = this._activeMaterialID;
                  }
               }
               break;
            case "v":
               this.parseVertex(param1);
               break;
            case "vt":
               this.parseUV(param1);
               break;
            case "vn":
               this.parseVertexNormal(param1);
               break;
            case "f":
               this.parseFace(param1);
         }
      }
      
      private function translate() : void
      {
         var _loc2_:Vector.<Group> = null;
         var _loc3_:uint = 0;
         var _loc4_:Vector.<MaterialGroup> = null;
         var _loc5_:uint = 0;
         var _loc6_:Geometry = null;
         var _loc7_:Mesh = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:MaterialBase = null;
         var _loc11_:uint = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this._objects.length)
         {
            _loc2_ = this._objects[_loc1_].groups;
            _loc3_ = _loc2_.length;
            _loc11_ = 0;
            while(_loc11_ < _loc3_)
            {
               _loc6_ = new Geometry();
               _loc4_ = _loc2_[_loc11_].materialGroups;
               _loc5_ = _loc4_.length;
               _loc8_ = 0;
               while(_loc8_ < _loc5_)
               {
                  this.translateMaterialGroup(_loc4_[_loc8_],_loc6_);
                  _loc8_++;
               }
               if(_loc6_.subGeometries.length != 0)
               {
                  finalizeAsset(_loc6_,"");
                  if(materialMode < 2)
                  {
                     _loc10_ = new TextureMaterial(DefaultMaterialManager.getDefaultTexture());
                  }
                  else
                  {
                     _loc10_ = new TextureMultiPassMaterial(DefaultMaterialManager.getDefaultTexture());
                  }
                  _loc7_ = new Mesh(_loc6_,_loc10_);
                  if(this._objects[_loc1_].name)
                  {
                     _loc7_.name = this._objects[_loc1_].name;
                  }
                  else if(_loc2_[_loc11_].name)
                  {
                     _loc7_.name = _loc2_[_loc11_].name;
                  }
                  else
                  {
                     _loc7_.name = "";
                  }
                  this._meshes.push(_loc7_);
                  if(_loc2_[_loc11_].materialID != "")
                  {
                     _loc10_.name = _loc2_[_loc11_].materialID + "~" + _loc7_.name;
                  }
                  else
                  {
                     _loc10_.name = this._lastMtlID + "~" + _loc7_.name;
                  }
                  if(_loc7_.subMeshes.length > 1)
                  {
                     _loc9_ = 1;
                     while(_loc9_ < _loc7_.subMeshes.length)
                     {
                        _loc7_.subMeshes[_loc9_].material = _loc10_;
                        _loc9_++;
                     }
                  }
                  finalizeAsset(_loc7_);
               }
               _loc11_++;
            }
            _loc1_++;
         }
      }
      
      private function translateMaterialGroup(param1:MaterialGroup, param2:Geometry) : void
      {
         var _loc4_:FaceData = null;
         var _loc6_:uint = 0;
         var _loc7_:Vector.<ISubGeometry> = null;
         var _loc12_:uint = 0;
         var _loc3_:Vector.<FaceData> = param1.faces;
         var _loc5_:uint = _loc3_.length;
         var _loc8_:Vector.<Number> = new Vector.<Number>();
         var _loc9_:Vector.<Number> = new Vector.<Number>();
         var _loc10_:Vector.<Number> = new Vector.<Number>();
         var _loc11_:Vector.<uint> = new Vector.<uint>();
         this._realIndices = [];
         this._vertexIndex = 0;
         var _loc13_:uint = 0;
         while(_loc13_ < _loc5_)
         {
            _loc4_ = _loc3_[_loc13_];
            _loc6_ = _loc4_.indexIds.length - 1;
            _loc12_ = 1;
            while(_loc12_ < _loc6_)
            {
               this.translateVertexData(_loc4_,_loc12_,_loc8_,_loc9_,_loc11_,_loc10_);
               this.translateVertexData(_loc4_,0,_loc8_,_loc9_,_loc11_,_loc10_);
               this.translateVertexData(_loc4_,_loc12_ + 1,_loc8_,_loc9_,_loc11_,_loc10_);
               _loc12_++;
            }
            _loc13_++;
         }
         if(_loc8_.length > 0)
         {
            _loc7_ = GeomUtil.fromVectors(_loc8_,_loc11_,_loc9_,_loc10_,null,null,null);
            _loc13_ = 0;
            while(_loc13_ < _loc7_.length)
            {
               param2.addSubGeometry(_loc7_[_loc13_]);
               _loc13_++;
            }
         }
      }
      
      private function translateVertexData(param1:FaceData, param2:int, param3:Vector.<Number>, param4:Vector.<Number>, param5:Vector.<uint>, param6:Vector.<Number>) : void
      {
         var index:uint = 0;
         var vertex:Vertex = null;
         var vertexNormal:Vertex = null;
         var uv:UV = null;
         var face:FaceData = param1;
         var vertexIndex:int = param2;
         var vertices:Vector.<Number> = param3;
         var uvs:Vector.<Number> = param4;
         var indices:Vector.<uint> = param5;
         var normals:Vector.<Number> = param6;
         if(!this._realIndices[face.indexIds[vertexIndex]])
         {
            index = this._vertexIndex;
            this._realIndices[face.indexIds[vertexIndex]] = ++this._vertexIndex;
            vertex = this._vertices[face.vertexIndices[vertexIndex] - 1];
            vertices.push(vertex.x * this._scale,vertex.y * this._scale,vertex.z * this._scale);
            if(face.normalIndices.length > 0)
            {
               vertexNormal = this._vertexNormals[face.normalIndices[vertexIndex] - 1];
               normals.push(vertexNormal.x,vertexNormal.y,vertexNormal.z);
            }
            if(face.uvIndices.length > 0)
            {
               try
               {
                  uv = this._uvs[face.uvIndices[vertexIndex] - 1];
                  uvs.push(uv.u,uv.v);
               }
               catch(e:Error)
               {
                  switch(vertexIndex)
                  {
                     case 0:
                        uvs.push(0,1);
                        break;
                     case 1:
                        uvs.push(0.5,0);
                        break;
                     case 2:
                        uvs.push(1,1);
                  }
               }
            }
         }
         else
         {
            index = this._realIndices[face.indexIds[vertexIndex]] - 1;
         }
         indices.push(index);
      }
      
      private function createObject(param1:Array) : void
      {
         this._currentGroup = null;
         this._currentMaterialGroup = null;
         this._objects.push(this._currentObject = new ObjectGroup());
         if(param1)
         {
            this._currentObject.name = param1[1];
         }
      }
      
      private function createGroup(param1:Array) : void
      {
         if(!this._currentObject)
         {
            this.createObject(null);
         }
         this._currentGroup = new Group();
         this._currentGroup.materialID = this._activeMaterialID;
         if(param1)
         {
            this._currentGroup.name = param1[1];
         }
         this._currentObject.groups.push(this._currentGroup);
         this.createMaterialGroup(null);
      }
      
      private function createMaterialGroup(param1:Array) : void
      {
         this._currentMaterialGroup = new MaterialGroup();
         if(param1)
         {
            this._currentMaterialGroup.url = param1[1];
         }
         this._currentGroup.materialGroups.push(this._currentMaterialGroup);
      }
      
      private function parseVertex(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         if(param1.length > 4)
         {
            _loc2_ = [];
            _loc4_ = 1;
            while(_loc4_ < param1.length)
            {
               _loc3_ = parseFloat(param1[_loc4_]);
               if(!isNaN(_loc3_))
               {
                  _loc2_.push(_loc3_);
               }
               _loc4_++;
            }
            this._vertices.push(new Vertex(_loc2_[0],_loc2_[1],-_loc2_[2]));
         }
         else
         {
            this._vertices.push(new Vertex(parseFloat(param1[1]),parseFloat(param1[2]),-parseFloat(param1[3])));
         }
      }
      
      private function parseUV(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         if(param1.length > 3)
         {
            _loc2_ = [];
            _loc4_ = 1;
            while(_loc4_ < param1.length)
            {
               _loc3_ = parseFloat(param1[_loc4_]);
               if(!isNaN(_loc3_))
               {
                  _loc2_.push(_loc3_);
               }
               _loc4_++;
            }
            this._uvs.push(new UV(_loc2_[0],1 - _loc2_[1]));
         }
         else
         {
            this._uvs.push(new UV(parseFloat(param1[1]),1 - parseFloat(param1[2])));
         }
      }
      
      private function parseVertexNormal(param1:Array) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         if(param1.length > 4)
         {
            _loc2_ = [];
            _loc4_ = 1;
            while(_loc4_ < param1.length)
            {
               _loc3_ = parseFloat(param1[_loc4_]);
               if(!isNaN(_loc3_))
               {
                  _loc2_.push(_loc3_);
               }
               _loc4_++;
            }
            this._vertexNormals.push(new Vertex(_loc2_[0],_loc2_[1],-_loc2_[2]));
         }
         else
         {
            this._vertexNormals.push(new Vertex(parseFloat(param1[1]),parseFloat(param1[2]),-parseFloat(param1[3])));
         }
      }
      
      private function parseFace(param1:Array) : void
      {
         var _loc4_:Array = null;
         var _loc2_:uint = param1.length;
         var _loc3_:FaceData = new FaceData();
         if(!this._currentGroup)
         {
            this.createGroup(null);
         }
         var _loc5_:uint = 1;
         while(_loc5_ < _loc2_)
         {
            if(param1[_loc5_] != "")
            {
               _loc4_ = param1[_loc5_].split("/");
               _loc3_.vertexIndices.push(this.parseIndex(parseInt(_loc4_[0]),this._vertices.length));
               if(Boolean(_loc4_[1]) && String(_loc4_[1]).length > 0)
               {
                  _loc3_.uvIndices.push(this.parseIndex(parseInt(_loc4_[1]),this._uvs.length));
               }
               if(Boolean(_loc4_[2]) && String(_loc4_[2]).length > 0)
               {
                  _loc3_.normalIndices.push(this.parseIndex(parseInt(_loc4_[2]),this._vertexNormals.length));
               }
               _loc3_.indexIds.push(param1[_loc5_]);
            }
            _loc5_++;
         }
         this._currentMaterialGroup.faces.push(_loc3_);
      }
      
      private function parseIndex(param1:int, param2:uint) : int
      {
         if(param1 < 0)
         {
            return param1 + param2 + 1;
         }
         return param1;
      }
      
      private function parseMtl(param1:String) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:BasicSpecularMethod = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:String = null;
         var _loc16_:SpecularData = null;
         var _loc17_:LoadedMaterial = null;
         var _loc18_:MaterialBase = null;
         var _loc2_:Array = param1.split("newmtl");
         var _loc15_:uint = 0;
         while(_loc15_ < _loc2_.length)
         {
            _loc3_ = (_loc2_[_loc15_].split("\r") as Array).join("").split("\n");
            if(_loc3_.length == 1)
            {
               _loc3_ = _loc2_[_loc15_].split(String.fromCharCode(13));
            }
            _loc9_ = _loc10_ = _loc11_ = 16777215;
            _loc12_ = 0;
            _loc7_ = false;
            _loc8_ = false;
            _loc13_ = 1;
            _loc14_ = "";
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length)
            {
               _loc3_[_loc5_] = _loc3_[_loc5_].replace(/\s+$/,"");
               if(_loc3_[_loc5_].substring(0,1) != "#" && (_loc5_ == 0 || _loc3_[_loc5_] != ""))
               {
                  _loc4_ = _loc3_[_loc5_].split(" ");
                  if(String(_loc4_[0]).charCodeAt(0) == 9 || String(_loc4_[0]).charCodeAt(0) == 32)
                  {
                     _loc4_[0] = _loc4_[0].substring(1,_loc4_[0].length);
                  }
                  if(_loc5_ == 0)
                  {
                     this._lastMtlID = _loc4_.join("");
                     this._lastMtlID = this._lastMtlID == "" ? "def000" : this._lastMtlID;
                  }
                  else
                  {
                     switch(_loc4_[0])
                     {
                        case "Ka":
                           if(Boolean(_loc4_[1] && !isNaN(Number(_loc4_[1])) && _loc4_[2]) && Boolean(!isNaN(Number(_loc4_[2]))) && Boolean(_loc4_[3]) && !isNaN(Number(_loc4_[3])))
                           {
                              _loc10_ = uint(_loc4_[1] * 255 << 16 | _loc4_[2] * 255 << 8 | _loc4_[3] * 255);
                           }
                           break;
                        case "Ks":
                           if(Boolean(_loc4_[1] && !isNaN(Number(_loc4_[1])) && _loc4_[2]) && Boolean(!isNaN(Number(_loc4_[2]))) && Boolean(_loc4_[3]) && !isNaN(Number(_loc4_[3])))
                           {
                              _loc11_ = uint(_loc4_[1] * 255 << 16 | _loc4_[2] * 255 << 8 | _loc4_[3] * 255);
                              _loc7_ = true;
                           }
                           break;
                        case "Ns":
                           if(Boolean(_loc4_[1]) && !isNaN(Number(_loc4_[1])))
                           {
                              _loc12_ = Number(_loc4_[1]) * 0.001;
                           }
                           if(_loc12_ == 0)
                           {
                              _loc7_ = false;
                           }
                           break;
                        case "Kd":
                           if(Boolean(_loc4_[1] && !isNaN(Number(_loc4_[1])) && _loc4_[2]) && Boolean(!isNaN(Number(_loc4_[2]))) && Boolean(_loc4_[3]) && !isNaN(Number(_loc4_[3])))
                           {
                              _loc9_ = uint(_loc4_[1] * 255 << 16 | _loc4_[2] * 255 << 8 | _loc4_[3] * 255);
                              _loc8_ = true;
                           }
                           break;
                        case "tr":
                        case "d":
                           if(Boolean(_loc4_[1]) && !isNaN(Number(_loc4_[1])))
                           {
                              _loc13_ = Number(_loc4_[1]);
                           }
                           break;
                        case "map_Kd":
                           _loc14_ = this.parseMapKdString(_loc4_);
                           _loc14_ = _loc14_.replace(/\\/g,"/");
                     }
                  }
               }
               _loc5_++;
            }
            if(_loc14_ != "")
            {
               if(_loc7_)
               {
                  _loc6_ = new BasicSpecularMethod();
                  _loc6_.specularColor = _loc11_;
                  _loc6_.specular = _loc12_;
                  _loc16_ = new SpecularData();
                  _loc16_.alpha = _loc13_;
                  _loc16_.basicSpecularMethod = _loc6_;
                  _loc16_.materialID = this._lastMtlID;
                  if(!this._materialSpecularData)
                  {
                     this._materialSpecularData = new Vector.<SpecularData>();
                  }
                  this._materialSpecularData.push(_loc16_);
               }
               addDependency(this._lastMtlID,new URLRequest(_loc14_));
            }
            else if(_loc8_ && !isNaN(_loc9_))
            {
               _loc17_ = new LoadedMaterial();
               _loc17_.materialID = this._lastMtlID;
               if(_loc13_ == 0)
               {
               }
               if(materialMode < 2)
               {
                  _loc18_ = new ColorMaterial(_loc9_);
                  ColorMaterial(_loc18_).alpha = _loc13_;
                  ColorMaterial(_loc18_).ambientColor = _loc10_;
                  ColorMaterial(_loc18_).repeat = true;
                  if(_loc7_)
                  {
                     ColorMaterial(_loc18_).specularColor = _loc11_;
                     ColorMaterial(_loc18_).specular = _loc12_;
                  }
               }
               else
               {
                  _loc18_ = new ColorMultiPassMaterial(_loc9_);
                  ColorMultiPassMaterial(_loc18_).ambientColor = _loc10_;
                  ColorMultiPassMaterial(_loc18_).repeat = true;
                  if(_loc7_)
                  {
                     ColorMultiPassMaterial(_loc18_).specularColor = _loc11_;
                     ColorMultiPassMaterial(_loc18_).specular = _loc12_;
                  }
               }
               _loc17_.cm = _loc18_;
               this._materialLoaded.push(_loc17_);
               if(this._meshes.length > 0)
               {
                  this.applyMaterial(_loc17_);
               }
            }
            _loc15_++;
         }
         this._mtlLibLoaded = true;
      }
      
      private function parseMapKdString(param1:Array) : String
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc2_:String = "";
         _loc3_ = 1;
         while(_loc3_ < param1.length)
         {
            switch(param1[_loc3_])
            {
               case "-blendu":
               case "-blendv":
               case "-cc":
               case "-clamp":
               case "-texres":
                  _loc3_ += 2;
                  break;
               case "-mm":
                  _loc3_ += 3;
                  break;
               case "-o":
               case "-s":
               case "-t":
                  _loc3_ += 4;
                  continue;
               default:
                  _loc4_ = true;
            }
            if(_loc4_)
            {
               break;
            }
         }
         while(_loc3_ < param1.length)
         {
            _loc2_ += param1[_loc3_];
            _loc2_ += " ";
            _loc3_++;
         }
         return _loc2_.replace(/\s+$/,"");
      }
      
      private function loadMtl(param1:String) : void
      {
         addDependency("mtl",new URLRequest(param1),true);
         pauseAndRetrieveDependencies();
      }
      
      private function applyMaterial(param1:LoadedMaterial) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Mesh = null;
         var _loc4_:MaterialBase = null;
         var _loc5_:uint = 0;
         var _loc6_:SpecularData = null;
         var _loc7_:uint = 0;
         while(_loc7_ < this._meshes.length)
         {
            _loc3_ = this._meshes[_loc7_];
            _loc2_ = _loc3_.material.name.split("~");
            if(_loc2_[0] == param1.materialID)
            {
               if(param1.cm)
               {
                  if(_loc3_.material)
                  {
                     _loc3_.material = null;
                  }
                  _loc3_.material = param1.cm;
               }
               else if(param1.texture)
               {
                  if(materialMode < 2)
                  {
                     _loc4_ = TextureMaterial(_loc3_.material);
                     TextureMaterial(_loc4_).texture = param1.texture;
                     TextureMaterial(_loc4_).ambientColor = param1.ambientColor;
                     TextureMaterial(_loc4_).alpha = param1.alpha;
                     TextureMaterial(_loc4_).repeat = true;
                     if(param1.specularMethod)
                     {
                        TextureMaterial(_loc4_).specularMethod = null;
                        TextureMaterial(_loc4_).specularMethod = param1.specularMethod;
                     }
                     else if(this._materialSpecularData)
                     {
                        _loc5_ = 0;
                        while(_loc5_ < this._materialSpecularData.length)
                        {
                           _loc6_ = this._materialSpecularData[_loc5_];
                           if(_loc6_.materialID == param1.materialID)
                           {
                              TextureMaterial(_loc4_).specularMethod = null;
                              TextureMaterial(_loc4_).specularMethod = _loc6_.basicSpecularMethod;
                              TextureMaterial(_loc4_).ambientColor = _loc6_.ambientColor;
                              TextureMaterial(_loc4_).alpha = _loc6_.alpha;
                              break;
                           }
                           _loc5_++;
                        }
                     }
                  }
                  else
                  {
                     _loc4_ = TextureMultiPassMaterial(_loc3_.material);
                     TextureMultiPassMaterial(_loc4_).texture = param1.texture;
                     TextureMultiPassMaterial(_loc4_).ambientColor = param1.ambientColor;
                     TextureMultiPassMaterial(_loc4_).repeat = true;
                     if(param1.specularMethod)
                     {
                        TextureMultiPassMaterial(_loc4_).specularMethod = null;
                        TextureMultiPassMaterial(_loc4_).specularMethod = param1.specularMethod;
                     }
                     else if(this._materialSpecularData)
                     {
                        _loc5_ = 0;
                        while(_loc5_ < this._materialSpecularData.length)
                        {
                           _loc6_ = this._materialSpecularData[_loc5_];
                           if(_loc6_.materialID == param1.materialID)
                           {
                              TextureMultiPassMaterial(_loc4_).specularMethod = null;
                              TextureMultiPassMaterial(_loc4_).specularMethod = _loc6_.basicSpecularMethod;
                              TextureMultiPassMaterial(_loc4_).ambientColor = _loc6_.ambientColor;
                              break;
                           }
                           _loc5_++;
                        }
                     }
                  }
               }
               _loc3_.material.name = _loc2_[1] ? _loc2_[1] : _loc2_[0];
               this._meshes.splice(_loc7_,1);
               _loc7_--;
            }
            _loc7_++;
         }
         if(Boolean(param1.cm) || Boolean(_loc4_))
         {
            finalizeAsset(param1.cm || _loc4_);
         }
      }
      
      private function applyMaterials() : void
      {
         if(this._materialLoaded.length == 0)
         {
            return;
         }
         var _loc1_:uint = 0;
         while(_loc1_ < this._materialLoaded.length)
         {
            this.applyMaterial(this._materialLoaded[_loc1_]);
            _loc1_++;
         }
      }
   }
}

import away3d.materials.MaterialBase;
import away3d.materials.methods.BasicSpecularMethod;
import away3d.textures.Texture2DBase;

class ObjectGroup
{
   
   public var name:String;
   
   public var groups:Vector.<Group> = new Vector.<Group>();
   
   public function ObjectGroup()
   {
      super();
   }
}

class Group
{
   
   public var name:String;
   
   public var materialID:String;
   
   public var materialGroups:Vector.<MaterialGroup> = new Vector.<MaterialGroup>();
   
   public function Group()
   {
      super();
   }
}

class MaterialGroup
{
   
   public var url:String;
   
   public var faces:Vector.<FaceData> = new Vector.<FaceData>();
   
   public function MaterialGroup()
   {
      super();
   }
}

class SpecularData
{
   
   public var materialID:String;
   
   public var basicSpecularMethod:BasicSpecularMethod;
   
   public var ambientColor:uint = 16777215;
   
   public var alpha:Number = 1;
   
   public function SpecularData()
   {
      super();
   }
}

class LoadedMaterial
{
   
   public var materialID:String;
   
   public var texture:Texture2DBase;
   
   public var cm:MaterialBase;
   
   public var specularMethod:BasicSpecularMethod;
   
   public var ambientColor:uint = 16777215;
   
   public var alpha:Number = 1;
   
   public function LoadedMaterial()
   {
      super();
   }
}

class FaceData
{
   
   public var vertexIndices:Vector.<uint> = new Vector.<uint>();
   
   public var uvIndices:Vector.<uint> = new Vector.<uint>();
   
   public var normalIndices:Vector.<uint> = new Vector.<uint>();
   
   public var indexIds:Vector.<String> = new Vector.<String>();
   
   public function FaceData()
   {
      super();
   }
}
