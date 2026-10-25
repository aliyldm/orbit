package net.bigpoint.darkorbit.map.model.ship.patterns
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.pattern.FullResourcePattern;
   
   public class ShipPattern
   {
      
      public static var I:int;
      
      public var playLoop:Boolean;
      
      public var laserClassID:int;
      
      public var rocketClassID:int;
      
      public var expansionClassID:String;
      
      public var explodeTypeID:int;
      
      public var engineTypeID:int;
      
      public var engineSmokeID:int;
      
      public var enginePositionClassID:String;
      
      public var effects:Array = [];
      
      public var clickRadius:int = 45;
      
      public var clickPriority:int = -1;
      
      private var _clickOffset:PointLite = new PointLite();
      
      public var rotatable:Boolean = true;
      
      public var podType:int = InGameCatalog.POD_TYPE_NONE;
      
      public var isLegendaryEventNPC:Boolean = false;
      
      private var _minimapIcon:String;
      
      private var _typeId:String;
      
      private var _baseTypeId:String;
      
      private var _classId:String;
      
      private var _podResPatterns:Vector.<FullResourcePattern>;
      
      private var _comment:String;
      
      public var simpleShipEnginePositions:Vector.<Vector.<PointLite>>;
      
      public var simpleShipSalvos:Vector.<Vector.<String>>;
      
      public var simpleShipCannons:Object;
      
      public var assetId:String;
      
      public var shipId:int;
      
      public var npcId:int;
      
      private var _name:String;
      
      private var _replacementName:String;
      
      public var icon:String;
      
      public var engine3DRes:String = "";
      
      public function ShipPattern(param1:String, param2:int, param3:int, param4:String)
      {
         super();
         ++I;
         this._typeId = param1;
         this._baseTypeId = this._typeId;
         this.shipId = param2;
         this.npcId = param3;
         this._name = param4;
      }
      
      public function get name() : String
      {
         if(this._replacementName != "" && this._replacementName != null)
         {
            return this._replacementName;
         }
         return this._name;
      }
      
      public function set name(param1:String) : void
      {
         this._name = param1;
      }
      
      public function set replacementName(param1:String) : void
      {
         this._replacementName = param1;
      }
      
      public function setPlayLoop(param1:Boolean) : void
      {
         this.playLoop = param1;
      }
      
      public function hasExpansion() : Boolean
      {
         return Boolean(this.expansionClassID);
      }
      
      public function setEngineTypeID(param1:int) : void
      {
         this.engineTypeID = param1;
      }
      
      public function getEngineTypeID() : int
      {
         return this.engineTypeID;
      }
      
      public function setEnginePositionClassID(param1:String) : void
      {
         this.enginePositionClassID = param1;
      }
      
      public function getEnginePositionClassID() : String
      {
         return this.enginePositionClassID;
      }
      
      public function getClickOffsetX() : int
      {
         return this._clickOffset.x;
      }
      
      public function setClickOffsetX(param1:int) : void
      {
         this._clickOffset.x = param1;
      }
      
      public function getClickOffsetY() : int
      {
         return this._clickOffset.y;
      }
      
      public function setClickOffsetY(param1:int) : void
      {
         this._clickOffset.y = param1;
      }
      
      public function get minimapIcon() : String
      {
         return this._minimapIcon;
      }
      
      public function set minimapIcon(param1:String) : void
      {
         this._minimapIcon = param1;
      }
      
      public function getEngineSmokeID() : int
      {
         return this.engineSmokeID;
      }
      
      public function clone() : ShipPattern
      {
         var _loc1_:ShipPattern = new ShipPattern(this._typeId,this.shipId,this.npcId,this._name);
         _loc1_.playLoop = this.playLoop;
         _loc1_.laserClassID = this.laserClassID;
         _loc1_.rocketClassID = this.rocketClassID;
         _loc1_.expansionClassID = this.expansionClassID;
         _loc1_.explodeTypeID = this.explodeTypeID;
         _loc1_.engineTypeID = this.engineTypeID;
         _loc1_.engineSmokeID = this.engineSmokeID;
         _loc1_.enginePositionClassID = this.enginePositionClassID;
         _loc1_.effects = this.effects;
         _loc1_.clickRadius = this.clickRadius;
         _loc1_.setClickOffsetX(this._clickOffset.x);
         _loc1_.setClickOffsetY(this._clickOffset.y);
         _loc1_.rotatable = this.rotatable;
         _loc1_.simpleShipEnginePositions = this.simpleShipEnginePositions;
         _loc1_.simpleShipCannons = this.simpleShipCannons;
         _loc1_.simpleShipSalvos = this.simpleShipSalvos;
         _loc1_.podType = this.podType;
         _loc1_.isLegendaryEventNPC = this.isLegendaryEventNPC;
         _loc1_.minimapIcon = this._minimapIcon;
         _loc1_.podResPatterns = this._podResPatterns;
         _loc1_.classId = this._classId;
         _loc1_.icon = this.icon;
         return _loc1_;
      }
      
      public function getPatternID() : String
      {
         return this._typeId;
      }
      
      public function set typeId(param1:String) : void
      {
         this._typeId = param1;
      }
      
      public function set classId(param1:String) : void
      {
         this._classId = param1;
      }
      
      public function get classId() : String
      {
         return this._classId;
      }
      
      public function set podResPatterns(param1:Vector.<FullResourcePattern>) : void
      {
         this._podResPatterns = param1;
      }
      
      public function getPodPattern(param1:int) : FullResourcePattern
      {
         var _loc2_:FullResourcePattern = null;
         var _loc3_:int = this._podResPatterns ? int(this._podResPatterns.length) : 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(this._podResPatterns[_loc4_].id == param1)
            {
               _loc2_ = this._podResPatterns[_loc4_];
               break;
            }
            _loc4_++;
         }
         return _loc2_ ? _loc2_ : this._podResPatterns[0];
      }
      
      public function set comment(param1:String) : void
      {
         this._comment = param1;
      }
      
      public function get comment() : String
      {
         return this._comment;
      }
      
      public function get typeId() : String
      {
         return this._typeId;
      }
      
      public function get baseTypeId() : String
      {
         return this._baseTypeId;
      }
   }
}

