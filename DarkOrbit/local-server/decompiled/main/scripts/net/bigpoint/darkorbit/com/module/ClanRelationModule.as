package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClanRelationModule implements IModule
   {
      
      private static var _instance:ClanRelationModule;
      
      public static const TYPE_NONE:int = 0;
      
      public static const TYPE_ALLIED:int = 1;
      
      public static const TYPE_NON_AGGRESSION_PACT:int = 2;
      
      public static const TYPE_AT_WAR:int = 3;
      
      public static const TYPE__MAX:int = 4;
      
      public var type:int = 0;
      
      public function ClanRelationModule(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : ClanRelationModule
      {
         return _instance || (_instance = new ClanRelationModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7010;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7010);
         param1.writeShort(this.type);
      }
   }
}

