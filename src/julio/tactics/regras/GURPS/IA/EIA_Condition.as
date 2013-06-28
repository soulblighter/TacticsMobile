package julio.tactics.regras.GURPS.IA
{
	import julio.enum.*;
	
	/**
	 * ...
	 * @author Júlio Cézar
	 */
	public class EIA_Condition extends EEnum
	{
    	{initEnum(EIA_Condition); } // static ctor
		
    	public static const HIGHEST_HP				:EIA_Condition = new EIA_Condition();
    	public static const LOWEST_HP				:EIA_Condition = new EIA_Condition();
    	public static const HIGHEST_MP				:EIA_Condition = new EIA_Condition();
    	public static const LOWEST_MP				:EIA_Condition = new EIA_Condition();
		
    	public static const HIGHEST_MAX_HP			:EIA_Condition = new EIA_Condition();
    	public static const LOWEST_MAX_HP			:EIA_Condition = new EIA_Condition();
    	public static const HIGHEST_MAX_MP			:EIA_Condition = new EIA_Condition();
    	public static const LOWES_MAXT_MP			:EIA_Condition = new EIA_Condition();
		
    	public static const HIGHEST_LEVEL			:EIA_Condition = new EIA_Condition();
    	public static const LOWEST_LEVEL			:EIA_Condition = new EIA_Condition();
		
    	public static const HIGHEST_ATTACK_POWER	:EIA_Condition = new EIA_Condition();
    	public static const LOWEST_ATTACK_POWER		:EIA_Condition = new EIA_Condition();
    	public static const HIGHEST_MAGIC_POWER		:EIA_Condition = new EIA_Condition();
    	public static const LOWEST_MAGIC_POWER		:EIA_Condition = new EIA_Condition();
		
    	public static const HIGHEST_DEFENSE			:EIA_Condition = new EIA_Condition();
    	public static const LOWEST_DEFENSE			:EIA_Condition = new EIA_Condition();
     	public static const HIGHEST_MAGIC_DEFENSE	:EIA_Condition = new EIA_Condition();
		public static const LOWEST_MAGIC_DEFENSE	:EIA_Condition = new EIA_Condition();
		
    	public static const HIGHEST_STATUS_DEFENSE	:EIA_Condition = new EIA_Condition();
    	public static const LOWEST_STATUS_DEFENSE	:EIA_Condition = new EIA_Condition();
     	public static const HIGHEST_SPEED			:EIA_Condition = new EIA_Condition();
		public static const LOWEST_SPEED			:EIA_Condition = new EIA_Condition();
		
		// HP: =0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
		// >=		// public static const HP_gt
		public static const HP_gt_10_p				:EIA_Condition = new EIA_Condition();
		public static const HP_gt_20_p				:EIA_Condition = new EIA_Condition();
		public static const HP_gt_30_p				:EIA_Condition = new EIA_Condition();
		public static const HP_gt_40_p				:EIA_Condition = new EIA_Condition();
		public static const HP_gt_50_p				:EIA_Condition = new EIA_Condition();
		public static const HP_gt_60_p				:EIA_Condition = new EIA_Condition();
		public static const HP_gt_70_p				:EIA_Condition = new EIA_Condition();
		public static const HP_gt_80_p				:EIA_Condition = new EIA_Condition();
		public static const HP_gt_90_p				:EIA_Condition = new EIA_Condition();
		// <=		// public static const HP_lt
		public static const HP_lt_90_p				:EIA_Condition = new EIA_Condition();
		public static const HP_lt_80_p				:EIA_Condition = new EIA_Condition();
		public static const HP_lt_70_p				:EIA_Condition = new EIA_Condition();
		public static const HP_lt_60_p				:EIA_Condition = new EIA_Condition();
		public static const HP_lt_50_p				:EIA_Condition = new EIA_Condition();
		public static const HP_lt_40_p				:EIA_Condition = new EIA_Condition();
		public static const HP_lt_30_p				:EIA_Condition = new EIA_Condition();
		public static const HP_lt_20_p				:EIA_Condition = new EIA_Condition();
		public static const HP_lt_10_p				:EIA_Condition = new EIA_Condition();
		
		// MP: =0%, =100%, >0%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%
		// >=		// public static const MP_gt
		public static const MP_gt_10_p				:EIA_Condition = new EIA_Condition();
		public static const MP_gt_20_p				:EIA_Condition = new EIA_Condition();
		public static const MP_gt_30_p				:EIA_Condition = new EIA_Condition();
		public static const MP_gt_40_p				:EIA_Condition = new EIA_Condition();
		public static const MP_gt_50_p				:EIA_Condition = new EIA_Condition();
		public static const MP_gt_60_p				:EIA_Condition = new EIA_Condition();
		public static const MP_gt_70_p				:EIA_Condition = new EIA_Condition();
		public static const MP_gt_80_p				:EIA_Condition = new EIA_Condition();
		public static const MP_gt_90_p				:EIA_Condition = new EIA_Condition();
		// <=		// public static const MP_lt
		public static const MP_lt_90_p				:EIA_Condition = new EIA_Condition();
		public static const MP_lt_80_p				:EIA_Condition = new EIA_Condition();
		public static const MP_lt_70_p				:EIA_Condition = new EIA_Condition();
		public static const MP_lt_60_p				:EIA_Condition = new EIA_Condition();
		public static const MP_lt_50_p				:EIA_Condition = new EIA_Condition();
		public static const MP_lt_40_p				:EIA_Condition = new EIA_Condition();
		public static const MP_lt_30_p				:EIA_Condition = new EIA_Condition();
		public static const MP_lt_20_p				:EIA_Condition = new EIA_Condition();
		public static const MP_lt_10_p				:EIA_Condition = new EIA_Condition();
		
		// Status: any, any debuff, any buff, KO, Sleep, Confuse, Blind, Poison, Silence, Immobilize, Slow, Protect, Shell, Haste, Invisible, Regen, Berserk, HP Critical(bloodied HP<50%), Near Death(HP<25%)
		// public static const STATUS
		public static const STATUS_any				:EIA_Condition = new EIA_Condition();
		public static const STATUS_any_debuff		:EIA_Condition = new EIA_Condition();
		public static const STATUS_any_buff			:EIA_Condition = new EIA_Condition();
		public static const STATUS_KO				:EIA_Condition = new EIA_Condition();
		public static const STATUS_bloodied			:EIA_Condition = new EIA_Condition();
		public static const STATUS_near_death		:EIA_Condition = new EIA_Condition();
/*
		public static const STATUS_Confuse			:EIA_Condition = new EIA_Condition();
		public static const STATUS_Blind			:EIA_Condition = new EIA_Condition();
		public static const STATUS_Poison			:EIA_Condition = new EIA_Condition();
		public static const STATUS_Silence			:EIA_Condition = new EIA_Condition();
		public static const STATUS_Immobilize		:EIA_Condition = new EIA_Condition();
		public static const STATUS_Slow				:EIA_Condition = new EIA_Condition();
		public static const STATUS_Protect			:EIA_Condition = new EIA_Condition();
		public static const STATUS_Shell			:EIA_Condition = new EIA_Condition();
		public static const STATUS_Haste			:EIA_Condition = new EIA_Condition();
		public static const STATUS_Invisible		:EIA_Condition = new EIA_Condition();
		public static const STATUS_Regen			:EIA_Condition = new EIA_Condition();
		public static const STATUS_Berserk			:EIA_Condition = new EIA_Condition();
*/
		// GURPS status
		public static const STATUS_Passive			:EIA_Condition = new EIA_Condition();	// De magicas como "Acalmar animais"
		public static const STATUS_Bravery			:EIA_Condition = new EIA_Condition();	// De magicas como "Dar Força"
		public static const STATUS_Fear				:EIA_Condition = new EIA_Condition();	// De magicas como "Medo"
		public static const STATUS_Defaith			:EIA_Condition = new EIA_Condition();	// De magicas como "Inépcia"
		public static const STATUS_Sleep			:EIA_Condition = new EIA_Condition();	// De magicas como "Topor"
		
		// alvo eh undead ou voa
		public static const UNDEAD					:EIA_Condition = new EIA_Condition();
		public static const FLYING					:EIA_Condition = new EIA_Condition();
		
		// elemental-weak:			fire, wind, water, earth, light, dark	(weak significa q o alvo recebe mais dano q o normal de fogo)
		// public static const ELEMENTAL_WEAK			:EIA_Condition = new EIA_Condition();
		public static const ELEMENTAL_FIRE_WEAK			:EIA_Condition = new EIA_Condition();
		public static const ELEMENTAL_WIND_WEAK			:EIA_Condition = new EIA_Condition();
		public static const ELEMENTAL_WATER_WEAK		:EIA_Condition = new EIA_Condition();
		public static const ELEMENTAL_EARTH_WEAK		:EIA_Condition = new EIA_Condition();
		public static const ELEMENTAL_LIGHT_WEAK		:EIA_Condition = new EIA_Condition();
		public static const ELEMENTAL_DEAK_WEAK			:EIA_Condition = new EIA_Condition();
		
		// elemental-vulnerable:	fire, wind, water, earth, light, dark	(vulnerable siginifica q o alvo recebe dano de fogo. i.e.: não eh imune)
		// public static const ELEMENTAL_VULNERABLE		:EIA_Condition = new EIA_Condition();
		public static const ELEMENTAL_FIRE_VULNERABLE	:EIA_Condition = new EIA_Condition();
		public static const ELEMENTAL_WIND_VULNERABLE	:EIA_Condition = new EIA_Condition();
		public static const ELEMENTAL_WATER_VULNERABLE	:EIA_Condition = new EIA_Condition();
		public static const ELEMENTAL_EARTH_VULNERABLE	:EIA_Condition = new EIA_Condition();
		public static const ELEMENTAL_LIGHT_VULNERABLE	:EIA_Condition = new EIA_Condition();
		public static const ELEMENTAL_DEAK_VULNERABLE	:EIA_Condition = new EIA_Condition();
		
		
		// alvo possui algum item roubável
		public static const HAS_ITEM				:EIA_Condition = new EIA_Condition();
		
		// personagem possui item para usar
		public static const SELF_HAS_ITEM			:EIA_Condition = new EIA_Condition();
		
		// alvo do lider do grupo atual
		public static const PARTY_LEADER_TARGET		:EIA_Condition = new EIA_Condition();
		
		// qualquer alvo
		public static const ANY						:EIA_Condition = new EIA_Condition();
		
		// alvo mais proximo
		public static const NEAREST					:EIA_Condition = new EIA_Condition();
		
		// alvo mais distante
		public static const FURTHEST				:EIA_Condition = new EIA_Condition();
		
		// lider do grupo inimigo
		public static const ENEMY_LEADER			:EIA_Condition = new EIA_Condition();
		
		// self HP:		=100%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%	(referente ao HP de quem faz a ação e não ao alvo)
		// public static const SELF_HP				:EIA_Condition = new EIA_Condition();
		// >=
		public static const SELF_HP_gt_10_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_gt_20_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_gt_30_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_gt_40_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_gt_50_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_gt_60_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_gt_70_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_gt_80_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_gt_90_p			:EIA_Condition = new EIA_Condition();
		// <=
		public static const SELF_HP_lt_90_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_lt_80_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_lt_70_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_lt_60_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_lt_50_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_lt_40_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_lt_30_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_lt_20_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_HP_lt_10_p			:EIA_Condition = new EIA_Condition();
		
		// self MP:		=100%, >10%, >20%, >30%, >40%, >50%, >60%, >70%, >80%, >90%, <10%, <20%, <30%, <40%, <50%, <60%, <70%, <80%, <90%, <100%	(referente ao MP de quem faz a ação e não ao alvo)
		// public static const SELF_MP					:EIA_Condition = new EIA_Condition();
		// >=
		public static const SELF_MP_gt_10_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_gt_20_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_gt_30_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_gt_40_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_gt_50_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_gt_60_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_gt_70_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_gt_80_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_gt_90_p			:EIA_Condition = new EIA_Condition();
		// <=
		public static const SELF_MP_lt_90_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_lt_80_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_lt_70_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_lt_60_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_lt_50_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_lt_40_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_lt_30_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_lt_20_p			:EIA_Condition = new EIA_Condition();
		public static const SELF_MP_lt_10_p			:EIA_Condition = new EIA_Condition();
		
		
		// seld Status:	any, any debuff, any buff, KO, Sleep, Confuse, Blind, Poison, Silence, Immobilize, Slow, Protect, Shell, Haste, Invisible, Regen, Berserk, bloodied(HP<50%), HP Critical(HP<25%) 	(referente ao status de quem faz a ação e não ao alvo)
		// public static const SELF_STATUS				:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_any				:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_any_debuff		:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_any_buff		:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_KO				:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_bloodied		:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_near_death		:EIA_Condition = new EIA_Condition();
/*
		public static const SELF_STATUS_Sleep			:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_Confuse			:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_Blind			:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_Poison			:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_Silence			:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_Immobilize		:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_Slow			:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_Protect			:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_Shell			:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_Haste			:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_Invisible		:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_Regen			:EIA_Condition = new EIA_Condition();
		public static const SELF_STATUS_Berserk			:EIA_Condition = new EIA_Condition();
*/
		// GURPS status
		public static const SELF_STATUS_Passive		:EIA_Condition = new EIA_Condition();	// De magicas como "Acalmar animais"
		public static const SELF_STATUS_Bravery		:EIA_Condition = new EIA_Condition();	// De magicas como "Dar Força"
		public static const SELF_STATUS_Fear		:EIA_Condition = new EIA_Condition();	// De magicas como "Medo"
		public static const SELF_STATUS_Defaith		:EIA_Condition = new EIA_Condition();	// De magicas como "Inépcia"
		public static const SELF_STATUS_Sleep		:EIA_Condition = new EIA_Condition();	// De magicas como "Topor"
	}
}

