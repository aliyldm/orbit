package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CompanyHierarchyInitializationCommand implements IModule
   {
      
      private static var _instance:CompanyHierarchyInitializationCommand;
      
      public var mmoRanking:Vector.<CompanyHierarchyRankingModule>;
      
      public var eicRanking:Vector.<CompanyHierarchyRankingModule>;
      
      public var vruRanking:Vector.<CompanyHierarchyRankingModule>;
      
      public var ownRanking:CompanyHierarchyRankingModule;
      
      public var ownFaction:FactionModule;
      
      public function CompanyHierarchyInitializationCommand(param1:Vector.<CompanyHierarchyRankingModule> = null, param2:Vector.<CompanyHierarchyRankingModule> = null, param3:Vector.<CompanyHierarchyRankingModule> = null, param4:CompanyHierarchyRankingModule = null, param5:FactionModule = null)
      {
         super();
         if(param1 == null)
         {
            this.mmoRanking = new Vector.<CompanyHierarchyRankingModule>();
         }
         else
         {
            this.mmoRanking = param1;
         }
         if(param2 == null)
         {
            this.eicRanking = new Vector.<CompanyHierarchyRankingModule>();
         }
         else
         {
            this.eicRanking = param2;
         }
         if(param3 == null)
         {
            this.vruRanking = new Vector.<CompanyHierarchyRankingModule>();
         }
         else
         {
            this.vruRanking = param3;
         }
         if(param4 == null)
         {
            this.ownRanking = new CompanyHierarchyRankingModule();
         }
         else
         {
            this.ownRanking = param4;
         }
         if(param5 == null)
         {
            this.ownFaction = new FactionModule();
         }
         else
         {
            this.ownFaction = param5;
         }
      }
      
      public static function get instance() : CompanyHierarchyInitializationCommand
      {
         return _instance || (_instance = new CompanyHierarchyInitializationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6007;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:CompanyHierarchyRankingModule = null;
         var _loc5_:CompanyHierarchyRankingModule = null;
         var _loc6_:CompanyHierarchyRankingModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.mmoRanking.length > 0)
         {
            this.mmoRanking.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CompanyHierarchyRankingModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.mmoRanking.push(_loc4_);
            _loc2_++;
         }
         while(this.eicRanking.length > 0)
         {
            this.eicRanking.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = CompanyHierarchyRankingModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.eicRanking.push(_loc5_);
            _loc2_++;
         }
         while(this.vruRanking.length > 0)
         {
            this.vruRanking.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = CompanyHierarchyRankingModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.vruRanking.push(_loc6_);
            _loc2_++;
         }
         this.ownRanking = CompanyHierarchyRankingModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.ownRanking)
         {
            this.ownRanking.read(param1);
         }
         this.ownFaction = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.ownFaction)
         {
            this.ownFaction.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:CompanyHierarchyRankingModule = null;
         var _loc3_:CompanyHierarchyRankingModule = null;
         var _loc4_:CompanyHierarchyRankingModule = null;
         param1.writeShort(6007);
         param1.writeByte(this.mmoRanking.length);
         for each(_loc2_ in this.mmoRanking)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.eicRanking.length);
         for each(_loc3_ in this.eicRanking)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.vruRanking.length);
         for each(_loc4_ in this.vruRanking)
         {
            _loc4_.write(param1);
         }
         if(null != this.ownRanking)
         {
            this.ownRanking.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.ownFaction)
         {
            this.ownFaction.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

