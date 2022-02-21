/**
  ******************************************************************************
  * @file           : main.c
  * @brief          : Main program body
  ******************************************************************************
  */

#include "stm32l4xx.h"

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
void StartPwmOnPA5(void);

/**
  * @brief  The application entry point.
  * @retval int
  */
int main(void)
{
  SystemClock_Config();
  StartPwmOnPA5();

  while (1)
  {
  }
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
#define RCC_HSICALIBRATION_DEFAULT     0x10U
void SystemClock_Config(void)
{
  /* Enable HSI16 clock */
  RCC->CR |= RCC_CR_HSION;
  while((RCC->CR & RCC_CR_HSIRDY_Msk) == 0U);

  /* Apply default calibration trim to HSI16 */
  RCC->ICSCR &= ~RCC_ICSCR_HSITRIM_Msk;
  RCC->ICSCR |= (RCC_HSICALIBRATION_DEFAULT << RCC_ICSCR_HSITRIM_Pos);

  /* Make sure PLL is off before configuration */
  RCC->CR &= ~RCC_CR_PLLON;
  while((RCC->CR & RCC_CR_PLLRDY_Msk) != 0U);

  /*
   * Configure PLL for 80MHz output on PLLCLK
   *   PLLM = /1, PLLN = x10, PLLR = /2
   */
  RCC->PLLCFGR =
      (2 << RCC_PLLCFGR_PLLSRC_Pos) |     /* Source = HSI16 */
      (10 << RCC_PLLCFGR_PLLN_Pos);

  /* Enable PLLR as SYSCLK */
  RCC->CR |= RCC_CR_PLLON;
  RCC->PLLCFGR |= RCC_PLLCFGR_PLLREN;
  while((RCC->CR & RCC_CR_PLLRDY_Msk) == 0U);

  /* Set FLASH latency to 4 wait states due to increased CPU frequency */
  uint32_t acr = FLASH->ACR;
  acr &= ~FLASH_ACR_LATENCY_Msk;
  acr |= (4 << FLASH_ACR_LATENCY_Pos);
  FLASH->ACR = acr;

  /* Set PLL as system clock */
  RCC->CFGR |= RCC_CFGR_SW_PLL;
  while((RCC->CFGR & RCC_CFGR_SWS_Msk) != RCC_CFGR_SWS_PLL);

  /* Set AHB, APB1 and APB2 prescalars to divide-by-1 */
  uint32_t cfgr = RCC->CFGR;
  cfgr &= ~(
      RCC_CFGR_HPRE_Msk |
      RCC_CFGR_PPRE1_Msk |
      RCC_CFGR_PPRE2_Msk);
  cfgr |= (
      RCC_CFGR_HPRE_DIV1 |
      RCC_CFGR_PPRE1_DIV1 |
      RCC_CFGR_PPRE2_DIV1);
  RCC->CFGR = cfgr;
}

/**
  * @brief  Begins 1Hz blink on PA5 using TIM2_CH1
  *         PA5 = Arduino D13 = Green LED on NUCLEO board
  *         TIM2_CH1 is alternate function 1 on PA5
  * @retval None
  */
void StartPwmOnPA5(void)
{
  /* Enable clocks to GPIOA and TIM2 peripherals */
  RCC->AHB2ENR |= RCC_AHB2ENR_GPIOAEN;
  RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;

  /* Select AF1 (TIM2_CH1) for PA5 */
  GPIOA->AFR[0] |= (1 << GPIO_AFRL_AFSEL5_Pos);

  /* Set PA5 in alternate function mode */
  GPIOA->MODER &= ~GPIO_MODER_MODE5_Msk;  /* Clear first since 11b is the reset state */
  GPIOA->MODER |= (2 << GPIO_MODER_MODE5_Pos);

  /* Disable the timer for configuration */
  TIM2->CR1 = 0;
  TIM2->CR2 = 0;

  /* Prescale by 10k.  At 80MHz, this gives tick freq of 8kHz */
  TIM2->PSC = 9999;   /* Prescalar = (PSC + 1) */

  /* Count from 0 to 7999 then roll over */
  TIM2->CR1 |= TIM_CR1_ARPE;
  TIM2->ARR = 7999;

  /*
   * Output Compare Mode 1 is set to 0110b, which is PWM mode 1
   *   Channel 1 is active as long as TIM2_CNT < TIM2_CCR1
   *   and inactive otherwise.
   */
  TIM2->CCMR1 =
      TIM_CCMR1_OC1PE |
      (6 << TIM_CCMR1_OC1M_Pos);
  TIM2->CCER = TIM_CCER_CC1E;

  /* Toggle CH1 output at half count */
  TIM2->CCR1 = 4000;

  /* Enable TIM2 thus starting PA5 1Hz PWM */
  TIM2->EGR |= TIM_EGR_UG;
  TIM2->CR1 |= TIM_CR1_CEN;
}

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
  /* USER CODE BEGIN Error_Handler_Debug */
  /* User can add his own implementation to report the HAL error return state */
  __disable_irq();
  while (1)
  {
  }
  /* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
}
#endif /* USE_FULL_ASSERT */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
