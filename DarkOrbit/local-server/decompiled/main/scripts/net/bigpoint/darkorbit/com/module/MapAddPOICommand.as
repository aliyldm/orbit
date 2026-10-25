package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MapAddPOICommand implements IModule
   {
      
      private static var _instance:MapAddPOICommand;
      
      public static const SHAPETYPE_CIRCLE:int = 0;
      
      public static const SHAPETYPE_POLYGON:int = 1;
      
      public static const SHAPETYPE_RECTANGLE:int = 2;
      
      public static const SHAPETYPE__MAX:int = 3;
      
      public var inverted:Boolean = false;
      
      public var poiTypeSpecification:String = "";
      
      public var poiType:POITypeModule;
      
      public var shape:int = 0;
      
      public var active:Boolean = false;
      
      public var design:POIDesignModule;
      
      public var poiId:String = "";
      
      public var shapeCoordinates:Vector.<int>;
      
      public function MapAddPOICommand(param1:String = "", param2:POITypeModule = null, param3:String = "", param4:POIDesignModule = null, param5:int = 0, param6:Vector.<int> = null, param7:Boolean = false, param8:Boolean = false)
      {
         super();
         this.inverted = param7;
         this.poiTypeSpecification = param3;
         if(param2 == null)
         {
            this.poiType = new POITypeModule();
         }
         else
         {
            this.poiType = param2;
         }
         this.shape = param5;
         this.active = param8;
         if(param4 == null)
         {
            this.design = new POIDesignModule();
         }
         else
         {
            this.design = param4;
         }
         this.poiId = param1;
         if(param6 == null)
         {
            this.shapeCoordinates = new Vector.<int>();
         }
         else
         {
            this.shapeCoordinates = param6;
         }
      }
      
      public static function get instance() : MapAddPOICommand
      {
         return _instance || (_instance = new MapAddPOICommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29100;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.inverted = param1.readBoolean();
         this.poiTypeSpecification = param1.readUTF();
         this.poiType = POITypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.poiType)
         {
            this.poiType.read(param1);
         }
         this.shape = param1.readShort();
         this.active = param1.readBoolean();
         this.design = POIDesignModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.design)
         {
            this.design.read(param1);
         }
         this.poiId = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.shapeCoordinates.length > 0)
         {
            this.shapeCoordinates.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 6 % 32 | _loc4_ << 32 - 6 % 32;
            this.shapeCoordinates.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(-29100);
         param1.writeBoolean(this.inverted);
         param1.writeUTF(this.poiTypeSpecification);
         if(null != this.poiType)
         {
            this.poiType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.shape);
         param1.writeBoolean(this.active);
         if(null != this.design)
         {
            this.design.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeUTF(this.poiId);
         param1.writeByte(this.shapeCoordinates.length);
         for each(_loc2_ in this.shapeCoordinates)
         {
            param1.writeInt(_loc2_ << 6 % 32 | _loc2_ >>> 32 - 6 % 32);
         }
      }
   }
}

