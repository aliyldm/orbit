package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventActivationStateCommand implements IModule
   {
      
      private static var _instance:EventActivationStateCommand;
      
      public static const EVENTTYPE_FROSTED_GATES:int = 0;
      
      public static const EVENTTYPE_CHRISTMAS_TREES:int = 1;
      
      public static const EVENTTYPE_CARNIVAL_2013:int = 2;
      
      public static const EVENTTYPE_APRIL_FOOLS:int = 3;
      
      public static const EVENTTYPE_INFLUENCE_BATTLE:int = 4;
      
      public static const EVENTTYPE_INFLUENCE_BATTLE_VICTORY_BANNER:int = 5;
      
      public static const EVENTTYPE_MAP_REPLACEMENT:int = 6;
      
      public static const EVENTTYPE_EVENT_DOMINATING_FACTION:int = 7;
      
      public static const EVENTTYPE_DEMOLISHED_HQ:int = 8;
      
      public static const EVENTTYPE_BREACH:int = 9;
      
      public static const EVENTTYPE_ICEBERG:int = 10;
      
      public static const EVENTTYPE_PLAGUE_MOOD_ASSET:int = 11;
      
      public static const EVENTTYPE_PROPAGANDA_ASTEROIDS:int = 12;
      
      public static const EVENTTYPE_PROPAGANDA_ASTEROIDS_CARNIVAL:int = 13;
      
      public static const EVENTTYPE_PROPAGANDA_ASTEROIDS_EASTER2016:int = 14;
      
      public static const EVENTTYPE_PIXELATED_RENDERING_SETTING:int = 15;
      
      public static const EVENTTYPE_PERMAFROST_FISSURE_ASSEMBLY_WINDOW:int = 16;
      
      public static const EVENTTYPE__MAX:int = 17;
      
      public var type:int = 0;
      
      public var attributes:Vector.<EventActivationAttributeModule>;
      
      public var active:Boolean = false;
      
      public function EventActivationStateCommand(param1:int = 0, param2:Vector.<EventActivationAttributeModule> = null, param3:Boolean = false)
      {
         super();
         this.type = param1;
         if(param2 == null)
         {
            this.attributes = new Vector.<EventActivationAttributeModule>();
         }
         else
         {
            this.attributes = param2;
         }
         this.active = param3;
      }
      
      public static function get instance() : EventActivationStateCommand
      {
         return _instance || (_instance = new EventActivationStateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2211;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EventActivationAttributeModule = null;
         this.type = param1.readShort();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.attributes.length > 0)
         {
            this.attributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = EventActivationAttributeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.attributes.push(_loc4_);
            _loc2_++;
         }
         this.active = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EventActivationAttributeModule = null;
         param1.writeShort(2211);
         param1.writeShort(this.type);
         param1.writeByte(this.attributes.length);
         for each(_loc2_ in this.attributes)
         {
            _loc2_.write(param1);
         }
         param1.writeBoolean(this.active);
      }
   }
}

